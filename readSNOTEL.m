function out = readSNOTEL(filename, startRow, endRow)
% readSNOTEL Imports data from a SNOTEL .csv file as a matrix.
%   SNOTEL1035 = readSNOTEL(FILENAME) Reads data from text file FILENAME
%   for the default selection.
%
%   SNOTEL1035 = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from
%   rows STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   snotel1035 = importfile('snotel_1035.csv', 60, 5751);
%

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 60;
    endRow = inf;
end

%% Format for each line of text:
%   column1: text (%s)
%	column2: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue', -9999, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
out = table(dataArray{1:end-1}, 'VariableNames', {'Date','SWEmm','PRCPmm','TMAXC','TMINC','TMEANC','PRCPIncrmm'});

