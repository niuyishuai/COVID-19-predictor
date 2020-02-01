function [bestnet,bestperform] = createNNFit(x_data,target_data,nbneurals,nbtrains)
    % Solve an Input-Output Fitting problem with a Neural Network
    % Created 29-Jan-2020 19:59:36
    %
    % This script assumes these variables are defined:
    %
    %   x_data - input data.
    %   target_data - target data.
    % 
    %  Copyright 2020, Yi-Shuai NIU. All Rights Reserved.
    
    x = x_data;
    t = target_data;
    
    % Choose a Training Function
    % For a list of all training functions type: help nntrain
    % 'trainlm' is usually fastest.
    % 'trainbr' takes longer but may be better for challenging problems.
    % 'trainscg' uses less memory. Suitable in low memory situations.
    trainFcn = 'trainbr';  % Bayesian Regularization backpropagation.
    
    bestperform=inf;
    h=waitbar(0,'神经网络训练进度');
    for i=1:nbtrains
        waitbar(i/nbtrains,h,['训练进度...',num2str(i/nbtrains*100),'%']);
        % Create a Fitting Network
        hiddenLayerSize = nbneurals;
        net = fitnet(hiddenLayerSize,trainFcn);
        
        % Setup Division of Data for Training, Validation, Testing
        net.divideParam.trainRatio = 70/100;
        net.divideParam.valRatio = 15/100;
        net.divideParam.testRatio = 15/100;
        
        % Train the Network
        [net,tr] = train(net,x,t);
        
        % Test the Network
        y = net(x);
        performance = perform(net,t,y);
        if performance < bestperform
            bestnet=net;
            bestperform=performance;
        end
    end
    close(h);
    % View the Network
    %view(net)
    
    % Plots
    % Uncomment these lines to enable various plots.
    %figure, plotperform(tr)
    %figure, plottrainstate(tr)
    %figure, ploterrhist(e)
    %figure, plotregression(t,y)
    figure, plotfit(bestnet,x,t)
    
end