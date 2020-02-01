function data = importjsonFile(filename)
    % import data from json file
    %  Copyright 2020, Yi-Shuai NIU. All Rights Reserved.

    jsontext = fileread(filename);
    data = jsondecode(jsontext);
end