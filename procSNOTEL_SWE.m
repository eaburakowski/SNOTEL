% procSNOTEL_SWE.m 
% 
% EA Burakowski
% 2017-10-02
% elizabeth.burakowski@gmail.com
%
% procSNOTEL_SWE.m loads state-level .mat files created using procSNOTEL.m,
% which contain SNOTEL daily SWE data (in mm), 2000-2016.
% The script does the following:
%   - calculates percent missing data per winter
%   - removes years missing >25% of daily records
%   - removes stations missing > 2 years of data
%   - converts SWE (mm) to snow depth (mm), assuming snow density = 0.35,
%   or the maximum end of range for snow in western US, using the following
%   equation: SWE/density = depth
%   - sums the number of days per winter (December through March) with snow
%   depth greater than a user-defined threshold, snwd_thresh (>3" recommended)  
%   - calculates the state average # of snow days per winter
%   - ranks the winters from highest to lowest number of snow covered days

%
% Requires:
%   - state-level .mat files of SNOTEL SWE data
%   - snwd_thresh, value in mm for which day is considered snow-covered
%   - data_thresh, threshold of daily missing values per winter
%   - yr_thresh, threshold of missing years in time series.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% list of states for target analysis
states = ['AK';
          'AZ';
          'CA';
          'CO';
          'ID';
          'MT';
          'NM';
          'NV';
          'OR';
          'UT';
          'WA';
          'WY'];
states = cellstr(states);

% go to SNOTEL .mat directory
cd /Users/zubeneschamali/Documents/Data/SNOTEL/mat

% define start year, end year, US states, and climate variable
yrsrt = 2000;
yrend = 2016;

% Loop over states and SNOTEL sites
% Calculate missing data
fils = dir('*.mat');
for istate = 1:length(states)
    load(fils(istate).name)
    
    % list station IDs
    stations = who('snotel_*');
    stations = stations(1:end-5);   % remove last five (metadata)
    
    % Loop over stations within state
    for istation = 1:length(stations)
        data = eval(stations{istation});
        SWE = data.SWEmm;
        date = data.Date; % NEED TO CONVERT FROM STRING TO YYYY MM DD
        
        
    end
    
    
end









