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

% define start year, end year, other constants
yrsrt = 2000;
yrend = 2016;
years = (yrsrt:yrend)';
data_thresh = 0.25; % winter missing data threshold
yr_thresh = 2;      % time series missing years threshold 

% Loop over states and SNOTEL sites
% Calculate missing data
fils = dir('*.mat');

for istate = 1:length(states)
    load(fils(istate).name);
    fils(istate).name
    
    % list station IDs
    stations = who('snotel_*');
    stations = stations(1:end-5);   % remove last five (metadata)
    
    % Loop over stations within state
    for istation = 1:length(stations)
        
        % pull out station daily SWE data and convert to meters
        data = eval(stations{istation});
        SWE = data.SWEmm;
        SWE(find(SWE==-9999))=NaN;
        SWE = SWE/1000;
        
        % pull out dates and split into year and month
        date = str2double(split(data.Date,'-'));
        year = date(:,1);
        month = date(:,2);
        
        % Loop over years, pull out one winter of SWE data
        for iyr = 1:length(yrsrt:yrend)-1
            onewinter = SWE(find(year==years(iyr)&month>=11|year==years(iyr+1)&month<=4));
            if (length(find(isnan(onewinter)))/length(onewinter))<data_thresh
                SWEsum(iyr,istation)=nansum(onewinter);
                SWEmax(iyr,istation)=max(onewinter);
            else
                SWEsum(iyr,istation)=NaN;
                SWEmax(iyr,istation)=NaN;
            end
        end
        
        clear data SWE date year month SNWD
    end
    
    % Eliminate stations for which missing years (NaN) is > yr_thresh
    SWEsum_remove = [];
    for istation = 1:length(stations)
        if length(find(isnan(SWEsum(:,istation))))>yr_thresh
            SWEsum_remove = [SWEsum_remove;istation];
        else
            SWEsum_remove = SWEsum_remove;
        end
    end
    SWEsum(:,SWEsum_remove)=[];
 
    % Eliminate stations for which missing years (NaN) is > yr_thresh
    SWEmax_remove = [];
    for istation = 1:length(stations)
        if length(find(isnan(SWEmax(:,istation))))>yr_thresh
            SWEmax_remove = [SWEmax_remove;istation];
        else
            SWEmax_remove = SWEmax_remove;
        end
    end
    SWEmax(:,SWEmax_remove)=[];
    
    % Calculate statewide average snowdays
    State_SWEsum(:,istate) = nanmean(SWEsum,2);
    State_SWEmax(:,istate) = nanmean(SWEmax,2);
    
    %Plot statewide SWEsum and SWEmax per winter, 2000-2016
        figure(istate); clf
        set(gcf,'Color','white')
        set(gca,'FontSize',20)
    
        % y-axis
        yrs2 = 2001:2016;
    
        % plot time series
        p = plotyy(yrs2,State_SWEsum(:,istate),yrs2,State_SWEmax(:,istate))
    
        % plot options
        xlabel('Year Dec-Mar')
        ylabel(p(1),'SWE total (m)')
        ylabel(p(2),'SWE max (m)')
        title(states(istate,:));
        legend('SWEsum','SWEmax','Location','NorthEast')
        text(2001,max(SWEmax(:,istate)),sprintf('n = %d ',length(SWEsum(1,:))))
    
    % Rank statewide snow days, lowest to highest
    [rank, irank] = sort(SWEsum(:,istate));
    State_SWEsum_Rankings(:,istate) = yrs2(irank);
    
    [rank, irank] = sort(SWEmax(:,istate));
    State_SWEmax_Rankings(:,istate) = yrs2(irank);
    
    % Clean up
    clear stations SWEsum_remove SWEmax_remove
    clear snotel_*
    
end









