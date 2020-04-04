function [n_days,date_lst,D] = decode_DayCounts(daycounts,start_day,end_day)
    %  DECODE_DAYCOUNTS
    %   decode daycounts data (obtained from json api)
    %
    %  INPUT:
    %      daycounts : day counts data
    %      start_day : from 1
    %      end_day : smaller than the number of days in daycounts
    %  Output:
    %      n_days: double
    %      date_lst: n_days string
    %      D: data matrix
    %      (confirm_accum|suspect|dead_accum|heal_accum|now_severe|now_confirm)
    %
    %  Copyright 2020, Yi-Shuai NIU. All Rights Reserved.   
    % 
    if nargin==1
        start_day=1;
        end_day=size(daycounts,1);
    end
    n_days=end_day-start_day+1;
    date_lst=cell(n_days,1);
    n_features=6;
    D=zeros(n_days,n_features);
    for i=start_day:end_day
        idx = i - start_day + 1; % index in extracted data list
        date_lst{idx} = daycounts(i).date;
        if isa(daycounts(i).confirm,'char')
            D(idx,1)=str2double(daycounts(i).confirm);
            D(idx,2)=str2double(daycounts(i).suspect);
            D(idx,3)=str2double(daycounts(i).dead);
            D(idx,4)=str2double(daycounts(i).heal);
            D(idx,5)=str2double(daycounts(i).now_severe);
            D(idx,6)=str2double(daycounts(i).now_confrim); % confrim is database typo
        else
            D(idx,1)=daycounts(i).confirm;
            D(idx,2)=daycounts(i).suspect;
            D(idx,3)=daycounts(i).dead;
            D(idx,4)=daycounts(i).heal;
            D(idx,5)=daycounts(i).now_severe;
            D(idx,6)=daycounts(i).now_confrim;
        end
    end
end