function datacounts = decodejsonAPI(node)
    % decode json api nodes from internet
    %  Copyright 2020, Yi-Shuai NIU. All Rights Reserved.

    switch node
        case 2
            % QQ API (indirect)
            data = importjsonAPI('https://service-n9zsbooc-1252957949.gz.apigw.tencentcs.com/release/qq');
            % 升序排列数据
            [~,index] = sortrows({data.data.wuwei_ww_cn_day_counts.date}.'); data.data.wuwei_ww_cn_day_counts = data.data.wuwei_ww_cn_day_counts(index); clear index
            datacounts=data.data.wuwei_ww_cn_day_counts;
            return;
        case 1
            % QQ API (direct)
            data = importjsonAPI('https://view.inews.qq.com/g2/getOnsInfo?name=wuwei_ww_cn_day_counts');
            data = jsondecode(data.data);
            % 升序排列数据
            [~,index] = sortrows({data.date}.'); data = data(index); clear index
            datacounts=data;
            return;
    end
end