function [n_days,date_lst, confirm_data, suspect_data, dead_data, heal_data] = decode_DayCounts(daycounts)
    %  DECODE_DAYCOUNTS
    %   decode daycounts data (obtained from json api)
    %
    %  INPUT:
    %      daycounts : day counts data
    %  Output:
    %      n_days: double
    %      date_lst: n_days string
    %      confirm_data: n_days double
    %      suspect_data: n_days double 
    %      dead_data: n_days double
    %      heal_data: n_days double
    %
    %  Copyright 2020, Yi-Shuai NIU. All Rights Reserved.   
    % 
    n_days=size(daycounts,1);
    date_lst=cell(n_days,1);
    D_lst=zeros(n_days,4);
    for i=1:n_days
        date_lst{i} = daycounts(i).date;
        if isa(daycounts(i).confirm,'char')
            D_lst(i,1)=str2num(daycounts(i).confirm);
            D_lst(i,2)=str2num(daycounts(i).suspect);
            D_lst(i,3)=str2num(daycounts(i).dead);
            D_lst(i,4)=str2num(daycounts(i).heal);
        else
            D_lst(i,1)=daycounts(i).confirm;
            D_lst(i,2)=daycounts(i).suspect;
            D_lst(i,3)=daycounts(i).dead;
            D_lst(i,4)=daycounts(i).heal;
        end
    end
    
    confirm_data=D_lst(:,1)';
    suspect_data=D_lst(:,2)';
    dead_data=D_lst(:,3)';
    heal_data=D_lst(:,4)';
end