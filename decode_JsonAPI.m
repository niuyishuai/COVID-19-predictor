function daycounts = decode_JsonAPI(node)
    %  DECODE_JSONAPI
    %   decode data from json api (internet is required)
    %
    %  INPUT:
    %      node : index of node (0|1|(2))
    %             0: qq api (indirect, non official collection)
    %             1: qq api (direct, official collection of day counts)
    %             2: qq api (all, official collection of all information)
    %  Output:
    %      daycounts : data based on days
    %
    %  Copyright 2020, Yi-Shuai NIU. All Rights Reserved.   
    % 
    
    switch node
        case 0
            % QQ API (indirect)
            data = import_JsonAPI('https://service-n9zsbooc-1252957949.gz.apigw.tencentcs.com/release/qq');
            % 升序排列数据
            [~,index] = sortrows({data.data.wuwei_ww_cn_day_counts.date}.'); data.data.wuwei_ww_cn_day_counts = data.data.wuwei_ww_cn_day_counts(index); clear index
            daycounts=data.data.wuwei_ww_cn_day_counts;
            return;
        case 1
            % QQ API (direct)
            data = import_JsonAPI('https://view.inews.qq.com/g2/getOnsInfo?name=wuwei_ww_cn_day_counts');
            data = jsondecode(data.data);
            % 升序排列数据
            [~,index] = sortrows({data.date}.'); data = data(index); clear index
            daycounts=data;
            return;
        case 2
            % QQ API (all)
            data = import_JsonAPI('https://view.inews.qq.com/g2/getOnsInfo?name=disease_h5');
            data=jsondecode(data.data);
            daycounts=data.chinaDayList;
            return;
    end
end