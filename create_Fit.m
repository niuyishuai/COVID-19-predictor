function [fitresult, gof] = create_Fit(date_lst, data, type, label)
    %  create_Fit
    %   create a fit for nCov data
    %
    %  INPUT:
    %      date_lst: date list by days (X Input)
    %      data: Y Output
    %      type: Fit type ('exp','gauss','poly','smoothsplit')
    %      label: Title
    %  Output:
    %      fitresult : a fit object representing the fit.
    %      gof : structure with goodness-of fit info.
    %
    %  See also FIT, CFIT, SFIT.
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
            % estimate initial point
            [a,b]=max(data);
            c=(x_data-b).^2./(log(abs(a))-log(abs(data)));
            c=sqrt(mean(c(~isnan(c))));
            opts.StartPoint = [a,b,c];
            opts.Lower = [-inf,-inf,0];
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
    
    % Draw fit
    draw_Fit(n_days, date_lst, label, gof.rsquare, fitresult, xData, yData)
end