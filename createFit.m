function [fitresult, gof] = createFit(date_lst, data, type, label)
    %  Create a fit.
    %
    %  Data for 'nCov' fit:
    %      X Input : data_lst
    %      Y Output: data
    %      Fit type: type
    %      Title   : label
    %  Output:
    %      fitresult : a fit object representing the fit.
    %      gof : structure with goodness-of fit info.
    %
    %  另请参阅 FIT, CFIT, SFIT.
    %
    %  Copyright 2020, Yi-Shuai NIU. All Rights Reserved.    
    
    n_days = length(date_lst);
    x_data = 1:n_days;
    [xData, yData] = prepareCurveData( x_data(:), data(:) );
    
    switch type
        case 'exp'
            % Set up fittype and options.
            ft = fittype( 'exp1' );
            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Display = 'Off';
            %bb=mean(log(data(2:end)./data(1:end-1)));
            %aa=mean(data./exp(bb*x_data));
            %opts.StartPoint = [aa,bb];
            %opts.Lower=[0,0];
        case 'gauss'
            % Set up fittype and options.
            ft = fittype( 'gauss1' );
            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Display = 'Off';
            opts.StartPoint = [max(data),n_days,std(1:n_days)];
            opts.Lower = [0,1,0];
        case 'poly'
            ft = fittype( 'poly5' );
            opts = fitoptions();
        case 'smoothsplit'
            ft = fittype( 'smoothingspline' );
            opts = fitoptions( 'Method', 'SmoothingSpline' );
            opts.Normalize = 'on';
            opts.SmoothingParam = 0.999999583268374;
    end
    % Fit model to data.
    [fitresult, gof] = fit( xData, yData, ft, opts );
    
    % Plot fit with data.
    figure( 'Name', [label,': R-Square (', num2str(gof.rsquare),')']);
    h = plot( fitresult, xData, yData);
    h(2).LineWidth = 1.5;
    legend( h, '真实数据', '预测结果', 'Location', 'NorthEast', 'Interpreter', 'none' );
    set(gca,'XTick',1:1:n_days);
    xlim([1 n_days]);
    xticklabels(date_lst);
    % Label axes
    xlabel( '日期', 'Interpreter', 'none' );
    ylabel( '人数', 'Interpreter', 'none' );
    title([label,': R-Square (', num2str(gof.rsquare),')']);
    set(gcf,'position',[500 500 1000 500]);
    grid on
end