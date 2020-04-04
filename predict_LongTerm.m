function predict_LongTerm(traindata,testdata,predictors,predictornames,label)
    %  predict_LongTerm
    %   long term prediction
    %
    %  INPUT:
    %      nterms : number of terms (terms in data + terms for prediction)
    %      curterm: 
    %      predictors: list of predictors
    %      predictornames: list of names of predictors
    %      label: figure title 
    %             0: qq api (indirect, non official collection)
    %             1: qq api (direct, official collection of day counts)
    %             2: qq api (all, official collection of all information)
    %  Output:
    %      daycounts : data based on days
    %
    %  Copyright 2020, Yi-Shuai NIU. All Rights Reserved.   
    % 
    
    figure('Name',label); % set figure name
    curterm = length(traindata); % current term (length of the train data)
    nterms = curterm + length(testdata); % number of terms (terms in data + terms for prediction)
    terms=1:nterms;
        
    hold all;
    ymax=0; % control the high of the figure
    for p = predictors
        y=p{1}(terms);
        plot(terms,y,'Marker','o','LineWidth',1.5);
        ymax=max([y(:);ymax]);
    end
    
    realdata=[traindata(:);testdata(:)]';
    % draw real data
    plot(realdata,'r','Marker','p','MarkerSize',10,'LineStyle','none');
    
    % draw current term line
    plot([curterm,curterm],[0,ymax],'k--');
    xlim([1,nterms]);
    xlabel('期数(天)');
    ylabel('人数');
    str_legend=predictornames;
    str_legend{end+1}='真实数据';
    legend(str_legend,'Location','northwest');
    title(label); % set figure title
    hold off;
    grid on;
    saveas(gcf,[label '.jpg']);
end