function draw_Fit(n_days, date_lst, label,rsquare, fitresult, xData, yData)
    % Plot fit with data.
    figure( 'Name', [label,': R-Square (', num2str(rsquare),')']);
    h = plot( fitresult, xData, yData, 'o');
    h(1).LineWidth = 1.5;
    h(2).LineWidth = 1.5;
    legend( h, '��ʵ����', 'Ԥ����', 'Location', 'NorthEast', 'Interpreter', 'none' );
    set(gca,'XTick',1:1:n_days);
    xlim([1 n_days]);
    xticklabels(date_lst);
    % Label axes
    xlabel( '����', 'Interpreter', 'none' );
    ylabel( '����', 'Interpreter', 'none' );
    title([label,': R-Square (', num2str(rsquare),')']);
    set(gcf,'position',[500 500 1000 500]);
    grid on
end
