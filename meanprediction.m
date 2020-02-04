function value = meanprediction(lst,period)
    n = length(lst);
    value=0;
    for i=1:n
        value=value+lst{i}(period);
    end
    value=round(value/n);    
end