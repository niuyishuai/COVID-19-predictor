clc;
clear;
close all;
%% 数据
% 读取json文件
%data=importjsonFile('data/qq历史-0129.json');
% 或直接对接jsonAPI读取数据
data=importjsonAPI('https://service-n9zsbooc-1252957949.gz.apigw.tencentcs.com/release/qq'); % QQ数据

% 升序排列数据
[~,index] = sortrows({data.data.wuwei_ww_cn_day_counts.date}.'); data.data.wuwei_ww_cn_day_counts = data.data.wuwei_ww_cn_day_counts(index); clear index

%% 解析数据
daycounts = data.data.wuwei_ww_cn_day_counts;
n_days=size(daycounts,1);
date_lst=cell(n_days,1);
D_lst=zeros(n_days,4);
for i=1:n_days
    date_lst{i} = daycounts(i).date;
    D_lst(i,1)=str2num(daycounts(i).confirm);
    D_lst(i,2)=str2num(daycounts(i).suspect);
    D_lst(i,3)=str2num(daycounts(i).dead);
    D_lst(i,4)=str2num(daycounts(i).heal);
end

% 提取确诊人数
x_data=1:n_days;
confirm_data=D_lst(:,1)';
suspect_data=D_lst(:,2)';
dead_data=D_lst(:,3)';
heal_data=D_lst(:,4)';

% 画图
figure('Name','武汉新型冠状病毒增长趋势');
set(gcf,'position',[200 200 1000 600]);
subplot(2,1,1);
hold on;
plot(x_data,D_lst(:,1),'r-o','LineWidth',1.5);
plot(x_data,D_lst(:,2),'b-o','LineWidth',1.5);
set(gca,'XTick',1:1:n_days);
xlim([1 n_days]);
xlabel('时间');
ylabel('人数');
xticklabels(date_lst);
legend({'确诊','疑似'},'Location','northwest');
title('确诊 - 疑似');
hold off;

subplot(2,1,2);
hold on;
plot(x_data,D_lst(:,3),'k-o','LineWidth',1.5);
plot(x_data,D_lst(:,4),'g-o','LineWidth',1.5);
set(gca,'XTick',1:1:n_days);
xlim([1 n_days]);
xlabel('时间');
ylabel('人数');
xticklabels(date_lst);
legend({'死亡','治愈'},'Location','northwest');
title('死亡 - 治愈');
hold off;


%% 预测
% 高斯拟合预测
fprintf('--------------------------------\n');
fprintf('高斯拟合预测结果：\n');
[gauss_confirm_predictor,~]=createFit(date_lst,confirm_data,'gauss','确诊人数预测 (高斯拟合)');
fprintf('预测明日确诊人数:%d\n',round(gauss_confirm_predictor(n_days+1)));

[gauss_suspect_predictor,~]=createFit(date_lst,suspect_data,'gauss','疑似人数预测 (高斯拟合)');
fprintf('预测明日疑似人数:%d\n',round(gauss_suspect_predictor(n_days+1)));

[gauss_dead_predictor,~]=createFit(date_lst,dead_data,'gauss','死亡人数预测 (高斯拟合)');
fprintf('预测明日死亡人数:%d\n',round(gauss_dead_predictor(n_days+1)));

% 指数拟合预测
fprintf('--------------------------------\n');
fprintf('指数拟合预测结果：\n');
[exp_confirm_predictor,~]=createFit(date_lst,confirm_data,'exp','确诊人数预测 (指数拟合)');
fprintf('预测明日确诊人数:%d\n',round(exp_confirm_predictor(n_days+1)));

[exp_suspect_predictor,~]=createFit(date_lst,suspect_data,'exp','疑似人数预测 (指数拟合)');
fprintf('预测明日疑似人数:%d\n',round(exp_suspect_predictor(n_days+1)));

[exp_dead_predictor,~]=createFit(date_lst,dead_data,'exp','死亡人数预测 (指数拟合)');
fprintf('预测明日死亡人数:%d\n',round(exp_dead_predictor(n_days+1)));

% 神经网络预测
fprintf('--------------------------------\n');
fprintf('神经网络预测结果：\n');
[NN_confirm_predictor,~]=createNNFit(x_data,confirm_data,5,5);
fprintf('预测明日确诊人数:%d\n',round(NN_confirm_predictor(n_days+1)));

[NN_suspect_predictor,~]=createNNFit(x_data,suspect_data,5,5);
fprintf('预测明日疑似人数:%d\n',round(NN_suspect_predictor(n_days+1)));

[NN_dead_predictor,~]=createNNFit(x_data,dead_data,5,5);
fprintf('预测明日死亡人数:%d\n',round(NN_dead_predictor(n_days+1)));

% 三种方式平均预测结果
fprintf('--------------------------------\n');
fprintf('平均预测结果：\n');
fprintf('预测明日确诊人数:%d\n',round((gauss_confirm_predictor(n_days+1)+...
    exp_confirm_predictor(n_days+1)+NN_confirm_predictor(n_days+1))/3));
fprintf('预测明日疑似人数:%d\n',round((gauss_suspect_predictor(n_days+1)+...
    exp_suspect_predictor(n_days+1)+NN_suspect_predictor(n_days+1))/3));
fprintf('预测明日死亡人数:%d\n',round((gauss_dead_predictor(n_days+1)+...
    exp_dead_predictor(n_days+1)+NN_dead_predictor(n_days+1))/3));

%% 长期预测(一周)
nterms=n_days+7; % 总期数
curterm=n_days; %当前期
predictors={gauss_confirm_predictor,exp_confirm_predictor,NN_confirm_predictor}; % 预测器
predictornames = {'高斯拟合','指数拟合','神经网络'}; %预测器名称
label='确诊感染一周趋势预测'; % 标签
longtermpredictions(nterms,curterm,predictors,predictornames,label);