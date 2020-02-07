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
    % 画图
    figure('Name','武汉新型冠状病毒新增变化趋势');
    set(gcf,'position',[200 200 1200 700]);
    subplot(2,1,1);
    hold on;
    plot(x_data,confirm_data,'r-o','LineWidth',1.5);
    plot(x_data,suspect_data,'b-o','LineWidth',1.5);
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
    plot(x_data,dead_data,'k-o','LineWidth',1.5);
    plot(x_data,heal_data,'g-o','LineWidth',1.5);
    set(gca,'XTick',1:1:n_days);
    xlim([1 n_days]);
    xlabel('时间');
    ylabel('人数');
    xticklabels(date_lst);
    legend({'死亡','治愈'},'Location','northwest');
    title('死亡 - 治愈');
    hold off;
end