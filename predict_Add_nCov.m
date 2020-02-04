clc;
clear;
close all;
%% 数据
% 对接jsonAPI读取数据
data = importjsonAPI('https://view.inews.qq.com/g2/getOnsInfo?name=disease_h5');
data=jsondecode(data.data);
daycounts=data.chinaDayAddList;

%% 解析数据
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
figure('Name','武汉新型冠状病毒新增变化趋势');
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
%% 高斯拟合预测
fprintf('--------------------------------\n');
fprintf('高斯拟合预测结果：\n');
[gauss_confirm_predictor,~]=createFit(date_lst,confirm_data,'gauss','新增确诊人数预测 (高斯拟合)');
fprintf('预测明日确诊人数:%d\n',round(gauss_confirm_predictor(n_days+1)));

[gauss_suspect_predictor,~]=createFit(date_lst,suspect_data,'gauss','新增疑似人数预测 (高斯拟合)');
fprintf('预测明日疑似人数:%d\n',round(gauss_suspect_predictor(n_days+1)));

[gauss_dead_predictor,~]=createFit(date_lst,dead_data,'gauss','新增死亡人数预测 (高斯拟合)');
fprintf('预测明日死亡人数:%d\n',round(gauss_dead_predictor(n_days+1)));

%% 指数拟合预测
fprintf('--------------------------------\n');
fprintf('指数拟合预测结果：\n');
[exp_confirm_predictor,~]=createFit(date_lst,confirm_data,'exp','新增确诊人数预测 (指数拟合)');
fprintf('预测明日确诊人数:%d\n',round(exp_confirm_predictor(n_days+1)));

[exp_suspect_predictor,~]=createFit(date_lst,suspect_data,'exp','新增疑似人数预测 (指数拟合)');
fprintf('预测明日疑似人数:%d\n',round(exp_suspect_predictor(n_days+1)));

[exp_dead_predictor,~]=createFit(date_lst,dead_data,'exp','新增死亡人数预测 (指数拟合)');
fprintf('预测明日死亡人数:%d\n',round(exp_dead_predictor(n_days+1)));

%% 多项式拟合预测
fprintf('--------------------------------\n');
fprintf('多项式拟合预测结果：\n');
[poly_confirm_predictor,~]=createFit(date_lst,confirm_data,'poly','确诊人数预测 (五次多项式拟合)');
fprintf('预测明日确诊人数:%d\n',round(poly_confirm_predictor(n_days+1)));

[poly_suspect_predictor,~]=createFit(date_lst,suspect_data,'poly','疑似人数预测 (五次多项式拟合)');
fprintf('预测明日疑似人数:%d\n',round(poly_suspect_predictor(n_days+1)));

[poly_dead_predictor,~]=createFit(date_lst,dead_data,'poly','死亡人数预测 (五次多项式拟合)');
fprintf('预测明日死亡人数:%d\n',round(poly_dead_predictor(n_days+1)));

%% Smooth Splitting拟合预测
fprintf('--------------------------------\n');
fprintf('Smooth Splitting拟合预测结果：\n');
[smoothsplit_confirm_predictor,~]=createFit(date_lst,confirm_data,'smoothsplit','新增确诊人数预测 (smoothsplit)');
fprintf('预测明日确诊人数:%d\n',round(smoothsplit_confirm_predictor(n_days+1)));

[smoothsplit_suspect_predictor,~]=createFit(date_lst,suspect_data,'smoothsplit','新增疑似人数预测 (smoothsplit)');
fprintf('预测明日疑似人数:%d\n',round(smoothsplit_suspect_predictor(n_days+1)));

[smoothsplit_dead_predictor,~]=createFit(date_lst,dead_data,'smoothsplit','新增死亡人数预测 (smoothsplit)');
fprintf('预测明日死亡人数:%d\n',round(smoothsplit_dead_predictor(n_days+1)));

%% 神经网络预测
fprintf('--------------------------------\n');
fprintf('神经网络预测结果：\n');
[NN_confirm_predictor,~]=createNNFit(x_data,confirm_data,5,5);
fprintf('预测明日确诊人数:%d\n',round(NN_confirm_predictor(n_days+1)));

[NN_suspect_predictor,~]=createNNFit(x_data,suspect_data,5,5);
fprintf('预测明日疑似人数:%d\n',round(NN_suspect_predictor(n_days+1)));

[NN_dead_predictor,~]=createNNFit(x_data,dead_data,5,5);
fprintf('预测明日死亡人数:%d\n',round(NN_dead_predictor(n_days+1)));

%% 定义预测器列表
lst_confirm_predictors={gauss_confirm_predictor,poly_confirm_predictor,NN_confirm_predictor,smoothsplit_confirm_predictor};
lst_suspect_predictors={gauss_suspect_predictor,poly_suspect_predictor,NN_suspect_predictor,smoothsplit_suspect_predictor};
lst_dead_predictors={gauss_dead_predictor,poly_dead_predictor,NN_dead_predictor,smoothsplit_dead_predictor};

%% 三种方式平均预测结果
fprintf('--------------------------------\n');
fprintf('平均预测结果：\n');
fprintf('预测明日确诊人数:%d\n',meanprediction(lst_confirm_predictors,n_days+1));
fprintf('预测明日疑似人数:%d\n',meanprediction(lst_suspect_predictors,n_days+1));
fprintf('预测明日死亡人数:%d\n',meanprediction(lst_dead_predictors,n_days+1));

%% 长期预测(一周)
% 确诊
nterms=n_days+7; % 总期数
curterm=n_days; %当前期
predictornames = {'高斯拟合','多项式拟合','神经网络','SmoothSplitting'}; %预测器名称
label='新增确诊感染一周趋势预测'; % 标签
longtermpredictions(nterms,curterm,lst_confirm_predictors,predictornames,label);

% 疑似
predictornames = {'高斯拟合','多项式拟合','神经网络','SmoothSplitting'}; %预测器名称
label='新增疑似感染一周趋势预测'; % 标签
longtermpredictions(nterms,curterm,lst_suspect_predictors,predictornames,label);

% 死亡
predictornames = {'高斯拟合','多项式拟合','神经网络','SmoothSplitting'}; %预测器名称
label='新增死亡一周趋势预测'; % 标签
longtermpredictions(nterms,curterm,lst_dead_predictors,predictornames,label);
