clc;
clear;
close all;
%% ����
daycounts=decode_JsonAPI(1); % QQ API����


%% ��������
[n_days, date_lst, confirm_data, suspect_data, dead_data, heal_data] = decode_DayCounts(daycounts,1,size(daycounts,1)-1);
draw_GeneralInfo(date_lst, confirm_data, suspect_data, dead_data, heal_data);

%% Ԥ��
%% ��˹���Ԥ��
fprintf('--------------------------------\n');
fprintf('��˹���Ԥ������\n');
[gauss_confirm_predictor,~]=create_Fit(date_lst,confirm_data,'gauss','ȷ������Ԥ�� (��˹���)');
fprintf('Ԥ������ȷ������:%d\n',round(gauss_confirm_predictor(n_days+1)));

[gauss_suspect_predictor,~]=create_Fit(date_lst,suspect_data,'gauss','��������Ԥ�� (��˹���)');
fprintf('Ԥ��������������:%d\n',round(gauss_suspect_predictor(n_days+1)));

[gauss_dead_predictor,~]=create_Fit(date_lst,dead_data,'gauss','��������Ԥ�� (��˹���)');
fprintf('Ԥ��������������:%d\n',round(gauss_dead_predictor(n_days+1)));

%% ָ�����Ԥ��
fprintf('--------------------------------\n');
fprintf('ָ�����Ԥ������\n');
[exp_confirm_predictor,~]=create_Fit(date_lst,confirm_data,'exp','ȷ������Ԥ�� (ָ�����)');
fprintf('Ԥ������ȷ������:%d\n',round(exp_confirm_predictor(n_days+1)));

[exp_suspect_predictor,~]=create_Fit(date_lst,suspect_data,'exp','��������Ԥ�� (ָ�����)');
fprintf('Ԥ��������������:%d\n',round(exp_suspect_predictor(n_days+1)));

[exp_dead_predictor,~]=create_Fit(date_lst,dead_data,'exp','��������Ԥ�� (ָ�����)');
fprintf('Ԥ��������������:%d\n',round(exp_dead_predictor(n_days+1)));

%% ����ʽ���Ԥ��
fprintf('--------------------------------\n');
fprintf('����ʽ���Ԥ������\n');
[poly_confirm_predictor,~]=create_Fit(date_lst,confirm_data,'poly','ȷ������Ԥ�� (��ζ���ʽ���)');
fprintf('Ԥ������ȷ������:%d\n',round(poly_confirm_predictor(n_days+1)));

[poly_suspect_predictor,~]=create_Fit(date_lst,suspect_data,'poly','��������Ԥ�� (��ζ���ʽ���)');
fprintf('Ԥ��������������:%d\n',round(poly_suspect_predictor(n_days+1)));

[poly_dead_predictor,~]=create_Fit(date_lst,dead_data,'poly','��������Ԥ�� (��ζ���ʽ���)');
fprintf('Ԥ��������������:%d\n',round(poly_dead_predictor(n_days+1)));

%% Smooth Splitting���Ԥ��
fprintf('--------------------------------\n');
fprintf('Smooth Splitting���Ԥ������\n');
[smoothsplit_confirm_predictor,~]=create_Fit(date_lst,confirm_data,'smoothsplit','ȷ������Ԥ�� (smoothsplit)');
fprintf('Ԥ������ȷ������:%d\n',round(smoothsplit_confirm_predictor(n_days+1)));

[smoothsplit_suspect_predictor,~]=create_Fit(date_lst,suspect_data,'smoothsplit','��������Ԥ�� (smoothsplit)');
fprintf('Ԥ��������������:%d\n',round(smoothsplit_suspect_predictor(n_days+1)));

[smoothsplit_dead_predictor,~]=create_Fit(date_lst,dead_data,'smoothsplit','��������Ԥ�� (smoothsplit)');
fprintf('Ԥ��������������:%d\n',round(smoothsplit_dead_predictor(n_days+1)));

%% ������Ԥ��
fprintf('--------------------------------\n');
fprintf('������Ԥ������\n');
[NN_confirm_predictor,~]=create_NNFit(date_lst,confirm_data,5,5);
fprintf('Ԥ������ȷ������:%d\n',round(NN_confirm_predictor(n_days+1)));

[NN_suspect_predictor,~]=create_NNFit(date_lst,suspect_data,5,5);
fprintf('Ԥ��������������:%d\n',round(NN_suspect_predictor(n_days+1)));

[NN_dead_predictor,~]=create_NNFit(date_lst,dead_data,5,5);
fprintf('Ԥ��������������:%d\n',round(NN_dead_predictor(n_days+1)));

%% ����Ԥ�����б�
lst_confirm_predictors={gauss_confirm_predictor,poly_confirm_predictor,NN_confirm_predictor,smoothsplit_confirm_predictor};
lst_suspect_predictors={gauss_suspect_predictor,poly_suspect_predictor,NN_suspect_predictor,smoothsplit_suspect_predictor};
lst_dead_predictors={gauss_dead_predictor,poly_dead_predictor,NN_dead_predictor,smoothsplit_dead_predictor};

%% ���ַ�ʽƽ��Ԥ����
fprintf('--------------------------------\n');
fprintf('ƽ��Ԥ������\n');
fprintf('Ԥ������ȷ������:%d\n',meanprediction(lst_confirm_predictors,n_days+1));
fprintf('Ԥ��������������:%d\n',meanprediction(lst_suspect_predictors,n_days+1));
fprintf('Ԥ��������������:%d\n',meanprediction(lst_dead_predictors,n_days+1));

%% ����Ԥ��(һ��)
% ȷ��
nterms=n_days+7; % ������
curterm=n_days; %��ǰ��
predictornames = {'��˹���','����ʽ���','������','SmoothSplitting'}; %Ԥ��������
label='ȷ���Ⱦһ������Ԥ��'; % ��ǩ
predict_LongTerm(nterms,curterm,lst_confirm_predictors,predictornames,label);

% ����
predictornames = {'��˹���','����ʽ���','������','SmoothSplitting'}; %Ԥ��������
label='���Ƹ�Ⱦһ������Ԥ��'; % ��ǩ
predict_LongTerm(nterms,curterm,lst_suspect_predictors,predictornames,label);

% ����
predictornames = {'��˹���','����ʽ���','������','SmoothSplitting'}; %Ԥ��������
label='����һ������Ԥ��'; % ��ǩ
predict_LongTerm(nterms,curterm,lst_dead_predictors,predictornames,label);
