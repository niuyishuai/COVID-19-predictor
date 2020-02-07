function longtermpredictions(nterms,curterm,predictors,predictornames,label)
    figure('Name',label);
    terms=1:nterms;
    
    hold all;
    ymax=0;
    for p = predictors
        y=p{1}(terms);
        plot(terms,y,'Marker','o','LineWidth',1.5);
        ymax=max([y(:);ymax]);
    end
    
    plot([curterm,curterm],[0,ymax],'k--');
    xlim([1,nterms]);
    xlabel('期数(天)');
    ylabel('人数');
    legend(predictornames);
    title(label);
    hold off;
    grid on;
end