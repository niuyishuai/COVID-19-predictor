function data = import_JsonAPI(apiurl)
    %  import_JsonAPI
    %   import json data from internet through api url
    %
    %  INPUT:
    %      apiurl: url string
    %
    %  OUTPUT:
    %      data: output data
    %
    %  Copyright 2020, Yi-Shuai NIU. All Rights Reserved.

    jsontext = urlread(apiurl);
    data = jsondecode(jsontext);
end