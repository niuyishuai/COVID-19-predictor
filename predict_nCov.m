clc;
clear;
close all;
%% ����
% ��ȡjson�ļ�
%data=importjsonFile('data/qq��ʷ-0129.json');
% ��ֱ�ӶԽ�jsonAPI��ȡ����
data=importjsonAPI('https://service-n9zsbooc-1252957949.gz.apigw.tencentcs.com/release/qq'); % QQ����

% ������������
[~,index] = sortrows({data.data.wuwei_ww_cn_day_counts.date}.'); data.data.wuwei_ww_cn_day_counts = data.data.wuwei_ww_cn_day_counts(index); clear index

%% ��������
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

% ��ȡȷ������
x_data=1:n_days;
confirm_data=D_lst(:,1)';
suspect_data=D_lst(:,2)';
dead_data=D_lst(:,3)';
heal_data=D_lst(:,4)';

% ��ͼ
figure('Name','�人���͹�״������������');
set(gcf,'position',[200 200 1000 600]);
subplot(2,1,1);
hold on;
plot(x_data,D_lst(:,1),'r-o','LineWidth',1.5);
plot(x_data,D_lst(:,2),'b-o','LineWidth',1.5);
set(gca,'XTick',1:1:n_days);
xlim([1 n_days]);
xlabel('ʱ��');
ylabel('����');
xticklabels(date_lst);
legend({'ȷ��','����'},'Location','northwest');
title('ȷ�� - ����');
hold off;

subplot(2,1,2);
hold on;
plot(x_data,D_lst(:,3),'k-o','LineWidth',1.5);
plot(x_data,D_lst(:,4),'g-o','LineWidth',1.5);
set(gca,'XTick',1:1:n_days);
xlim([1 n_days]);
xlabel('ʱ��');
ylabel('����');
xticklabels(date_lst);
legend({'����','����'},'Location','northwest');
title('���� - ����');
hold off;


%% Ԥ��
% ��˹���Ԥ��
fprintf('--------------------------------\n');
fprintf('��˹���Ԥ������\n');
[gauss_confirm_predictor,~]=createFit(date_lst,confirm_data,'gauss','ȷ������Ԥ�� (��˹���)');
fprintf('Ԥ������ȷ������:%d\n',round(gauss_confirm_predictor(n_days+1)));

[gauss_suspect_predictor,~]=createFit(date_lst,suspect_data,'gauss','��������Ԥ�� (��˹���)');
fprintf('Ԥ��������������:%d\n',round(gauss_suspect_predictor(n_days+1)));

[gauss_dead_predictor,~]=createFit(date_lst,dead_data,'gauss','��������Ԥ�� (��˹���)');
fprintf('Ԥ��������������:%d\n',round(gauss_dead_predictor(n_days+1)));

% ָ�����Ԥ��
fprintf('--------------------------------\n');
fprintf('ָ�����Ԥ������\n');
[exp_confirm_predictor,~]=createFit(date_lst,confirm_data,'exp','ȷ������Ԥ�� (ָ�����)');
fprintf('Ԥ������ȷ������:%d\n',round(exp_confirm_predictor(n_days+1)));

[exp_suspect_predictor,~]=createFit(date_lst,suspect_data,'exp','��������Ԥ�� (ָ�����)');
fprintf('Ԥ��������������:%d\n',round(exp_suspect_predictor(n_days+1)));

[exp_dead_predictor,~]=createFit(date_lst,dead_data,'exp','��������Ԥ�� (ָ�����)');
fprintf('Ԥ��������������:%d\n',round(exp_dead_predictor(n_days+1)));

% ������Ԥ��
fprintf('--------------------------------\n');
fprintf('������Ԥ������\n');
[NN_confirm_predictor,~]=createNNFit(x_data,confirm_data,5,5);
fprintf('Ԥ������ȷ������:%d\n',round(NN_confirm_predictor(n_days+1)));

[NN_suspect_predictor,~]=createNNFit(x_data,suspect_data,5,5);
fprintf('Ԥ��������������:%d\n',round(NN_suspect_predictor(n_days+1)));

[NN_dead_predictor,~]=createNNFit(x_data,dead_data,5,5);
fprintf('Ԥ��������������:%d\n',round(NN_dead_predictor(n_days+1)));

% ���ַ�ʽƽ��Ԥ����
fprintf('--------------------------------\n');
fprintf('ƽ��Ԥ������\n');
fprintf('Ԥ������ȷ������:%d\n',round((gauss_confirm_predictor(n_days+1)+...
    exp_confirm_predictor(n_days+1)+NN_confirm_predictor(n_days+1))/3));
fprintf('Ԥ��������������:%d\n',round((gauss_suspect_predictor(n_days+1)+...
    exp_suspect_predictor(n_days+1)+NN_suspect_predictor(n_days+1))/3));
fprintf('Ԥ��������������:%d\n',round((gauss_dead_predictor(n_days+1)+...
    exp_dead_predictor(n_days+1)+NN_dead_predictor(n_days+1))/3));

%% ����Ԥ��(һ��)
nterms=n_days+7; % ������
curterm=n_days; %��ǰ��
predictors={gauss_confirm_predictor,exp_confirm_predictor,NN_confirm_predictor}; % Ԥ����
predictornames = {'��˹���','ָ�����','������'}; %Ԥ��������
label='ȷ���Ⱦһ������Ԥ��'; % ��ǩ
longtermpredictions(nterms,curterm,predictors,predictornames,label);