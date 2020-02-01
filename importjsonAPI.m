function data = importjsonAPI(apiurl)
    % import json data from internet through api url
    %  Copyright 2020, Yi-Shuai NIU. All Rights Reserved.

    jsontext = urlread(apiurl);
    data = jsondecode(jsontext);
end