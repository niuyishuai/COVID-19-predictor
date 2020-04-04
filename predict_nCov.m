clc;
clear;
close all;
%% 数据
daycounts=decode_JsonAPI(1); % QQ API数据


%% 解析数据
[n_days, date_lst, confirm_data, suspect_data, dead_data, heal_data] = decode_DayCounts(daycounts,1,size(daycounts,1)-1);
draw_GeneralInfo(date_lst, confirm_data, suspect_data, dead_data, heal_data);

%% 预测
%% 高斯拟合预测
fprintf('--------------------------------\n');
fprintf('高斯拟合预测结果：\n');
[gauss_confirm_predictor,~]=create_Fit(date_lst,confirm_data,'gauss','确诊人数预测 (高斯拟合)');
fprintf('预测明日确诊人数:%d\n',round(gauss_confirm_predictor(n_days+1)));

[gauss_suspect_predictor,~]=create_Fit(date_lst,suspect_data,'gauss','疑似人数预测 (高斯拟合)');
fprintf('预测明日疑似人数:%d\n',round(gauss_suspect_predictor(n_days+1)));

[gauss_dead_predictor,~]=create_Fit(date_lst,dead_data,'gauss','死亡人数预测 (高斯拟合)');
fprintf('预测明日死亡人数:%d\n',round(gauss_dead_predictor(n_days+1)));

%% 指数拟合预测
fprintf('--------------------------------\n');
fprintf('指数拟合预测结果：\n');
[exp_confirm_predictor,~]=create_Fit(date_lst,confirm_data,'exp','确诊人数预测 (指数拟合)');
fprintf('预测明日确诊人数:%d\n',round(exp_confirm_predictor(n_days+1)));

[exp_suspect_predictor,~]=create_Fit(date_lst,suspect_data,'exp','疑似人数预测 (指数拟合)');
fprintf('预测明日疑似人数:%d\n',round(exp_suspect_predictor(n_days+1)));

[exp_dead_predictor,~]=create_Fit(date_lst,dead_data,'exp','死亡人数预测 (指数拟合)');
fprintf('预测明日死亡人数:%d\n',round(exp_dead_predictor(n_days+1)));

%% 多项式拟合预测
fprintf('--------------------------------\n');
fprintf('多项式拟合预测结果：\n');
[poly_confirm_predictor,~]=create_Fit(date_lst,confirm_data,'poly','确诊人数预测 (五次多项式拟合)');
fprintf('预测明日确诊人数:%d\n',round(poly_confirm_predictor(n_days+1)));

[poly_suspect_predictor,~]=create_Fit(date_lst,suspect_data,'poly','疑似人数预测 (五次多项式拟合)');
fprintf('预测明日疑似人数:%d\n',round(poly_suspect_predictor(n_days+1)));

[poly_dead_predictor,~]=create_Fit(date_lst,dead_data,'poly','死亡人数预测 (五次多项式拟合)');
fprintf('预测明日死亡人数:%d\n',round(poly_dead_predictor(n_days+1)));

%% Smooth Splitting拟合预测
fprintf('--------------------------------\n');
fprintf('Smooth Splitting拟合预测结果：\n');
[smoothsplit_confirm_predictor,~]=create_Fit(date_lst,confirm_data,'smoothsplit','确诊人数预测 (smoothsplit)');
fprintf('预测明日确诊人数:%d\n',round(smoothsplit_confirm_predictor(n_days+1)));

[smoothsplit_suspect_predictor,~]=create_Fit(date_lst,suspect_data,'smoothsplit','疑似人数预测 (smoothsplit)');
fprintf('预测明日疑似人数:%d\n',round(smoothsplit_suspect_predictor(n_days+1)));

[smoothsplit_dead_predictor,~]=create_Fit(date_lst,dead_data,'smoothsplit','死亡人数预测 (smoothsplit)');
fprintf('预测明日死亡人数:%d\n',round(smoothsplit_dead_predictor(n_days+1)));

%% 神经网络预测
fprintf('--------------------------------\n');
fprintf('神经网络预测结果：\n');
[NN_confirm_predictor,~]=create_NNFit(date_lst,confirm_data,5,5);
fprintf('预测明日确诊人数:%d\n',round(NN_confirm_predictor(n_days+1)));

[NN_suspect_predictor,~]=create_NNFit(date_lst,suspect_data,5,5);
fprintf('预测明日疑似人数:%d\n',round(NN_suspect_predictor(n_days+1)));

[NN_dead_predictor,~]=create_NNFit(date_lst,dead_data,5,5);
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
label='确诊感染一周趋势预测'; % 标签
predict_LongTerm(nterms,curterm,lst_confirm_predictors,predictornames,label);

% 疑似
predictornames = {'高斯拟合','多项式拟合','神经网络','SmoothSplitting'}; %预测器名称
label='疑似感染一周趋势预测'; % 标签
predict_LongTerm(nterms,curterm,lst_suspect_predictors,predictornames,label);

% 死亡
predictornames = {'高斯拟合','多项式拟合','神经网络','SmoothSplitting'}; %预测器名称
label='死亡一周趋势预测'; % 标签
predict_LongTerm(nterms,curterm,lst_dead_predictors,predictornames,label);
