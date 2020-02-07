function data = import_JsonFile(filename)
    %  import_JsonFile
    %   import data from json file
    %
    %  INPUT:
    %      filename: filename string
    %
    %  OUTPUT:
    %      data: output data
    %
    %  Copyright 2020, Yi-Shuai NIU. All Rights Reserved.
    
    jsontext = fileread(filename);
    data = jsondecode(jsontext);
end