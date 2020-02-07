function draw_GeneralInfo(date_lst, confirm_data, suspect_data, dead_data, heal_data)
    %  DRAW_GENERALINFO
    %   draw general information (confirm_data, suspect_data, dead_data, heal_data)
    %
    %  INPUT:
    %      date_lst: n_days string
    %      confirm_data: n_days double
    %      suspect_data: n_days double 
    %      dead_data: n_days double
    %      heal_data: n_days double
    %
    %  Copyright 2020, Yi-Shuai NIU. All Rights Reserved.   
    % 
    
    n_days = length(date_lst);
    x_data = 1:n_days;
    % ��ͼ
    figure('Name','�人���͹�״���������仯����');
    set(gcf,'position',[200 200 1200 700]);
    subplot(2,1,1);
    hold on;
    plot(x_data,confirm_data,'r-o','LineWidth',1.5);
    plot(x_data,suspect_data,'b-o','LineWidth',1.5);
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
    plot(x_data,dead_data,'k-o','LineWidth',1.5);
    plot(x_data,heal_data,'g-o','LineWidth',1.5);
    set(gca,'XTick',1:1:n_days);
    xlim([1 n_days]);
    xlabel('ʱ��');
    ylabel('����');
    xticklabels(date_lst);
    legend({'����','����'},'Location','northwest');
    title('���� - ����');
    hold off;
end