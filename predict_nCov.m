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
n_days=size(daycounts,1)-1;
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
figure
hold on;
plot(x_data,D_lst(:,1),'r-o');
plot(x_data,D_lst(:,2),'b-o');
plot(x_data,D_lst(:,3),'k-o');
plot(x_data,D_lst(:,4),'g-o');
set(gca,'XTick',1:1:n_days);
set(gcf,'position',[200 200 1000 600]);
xlim([1 n_days]);
xlabel='时间';
ylabel='人数';
xticklabels(date_lst);
legend({'确诊','疑似','死亡','治愈'});
hold off;

%% 预测
% 高斯拟合预测
fprintf('--------------------------------\n');
fprintf('高斯拟合预测结果：\n');
[confirm_predictor,~]=createFit(date_lst,confirm_data,'gauss','确诊人数预测');
fprintf('预测明日确诊人数:%d\n',round(confirm_predictor(n_days+1)));

[suspect_predictor,~]=createFit(date_lst,suspect_data,'gauss','疑似人数预测');
fprintf('预测明日疑似人数:%d\n',round(suspect_predictor(n_days+1)));

[dead_predictor,~]=createFit(date_lst,dead_data,'gauss','死亡人数预测');
fprintf('预测明日死亡人数:%d\n',round(dead_predictor(n_days+1)));

% 指数拟合预测
fprintf('--------------------------------\n');
fprintf('指数拟合预测结果：\n');
[confirm_predictor,~]=createFit(date_lst,confirm_data,'exp','确诊人数预测');
fprintf('预测明日确诊人数:%d\n',round(confirm_predictor(n_days+1)));

[suspect_predictor,~]=createFit(date_lst,suspect_data,'exp','疑似人数预测');
fprintf('预测明日疑似人数:%d\n',round(suspect_predictor(n_days+1)));

[dead_predictor,~]=createFit(date_lst,dead_data,'exp','死亡人数预测');
fprintf('预测明日死亡人数:%d\n',round(dead_predictor(n_days+1)));

% 神经网络预测
fprintf('--------------------------------\n');
fprintf('神经网络预测结果：\n');
[NN_confirm_predictor,~]=createNNFit(x_data,confirm_data,5,5);
fprintf('预测明日确诊人数:%d\n',round(NN_confirm_predictor(n_days+1)));

[NN_suspect_predictor,~]=createNNFit(x_data,suspect_data,5,5);
fprintf('预测明日疑似人数:%d\n',round(NN_suspect_predictor(n_days+1)));

[NN_dead_predictor,~]=createNNFit(x_data,dead_data,5,5);
fprintf('预测明日死亡人数:%d\n',round(NN_dead_predictor(n_days+1)));