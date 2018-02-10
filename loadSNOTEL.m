% loadSNOTEL.m 
% 
% EA Burakowski
% 2017-10-01
% elizabeth.burakowski@gmail.com
%
% Loads SNOw TELemetry (SNOTEL) data into state-level .mat files
%
% Requires:
%   SNOTEL_Inventory_wheaders.mat (pull from SNOTEL website:
%   https://wcc.sc.egov.usda.gov/nwcc/yearcount?network=sntl&counttype=statelist&state=
%   - this file is a list of stations based on user-defined attributes.
%  
%   importSNOTEL_inv.m
%   - this script imports the metadata file (SNOTEL_Inventory)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd /Users/zubeneschamali/Documents/Data/SNOTEL/

importSNOTEL_inv

% Load metadata
SNOTEL_ID = SNOTELInv.stationid;
SNOTEL_lat = SNOTELInv.lat;
SNOTEL_lon = SNOTELInv.lon;
SNOTEL_elev = SNOTELInv.elev;
SNOTEL_state = cellstr(SNOTELInv.state);

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
      
% define start year, end year, US states, and climate variable
yrsrt = 1999;
yrend = 2016;

% other constants
filenameSpec = "snotel_%d.csv";
outnameSpec = "snotel_%d";

% list files in SNOTEL .csv directory, pull out site ID from filename
fils = dir('csv/*.csv');
for i = 1:length(fils)
    fils_id_str = strsplit(fils(i).name,{'_','.'},'CollapseDelimiters',true);
    fils_id(i) = str2num(fils_id_str{:,2});
end

% Loop over states and SNOTEL sites
for istate = 1:length(states)
    stations_ind = strmatch(states(istate),SNOTEL_state);
    
    % save metadata for specific state
    snotel_ID = SNOTEL_ID(stations_ind)
    snotel_lat = SNOTEL_lat(stations_ind)
    snotel_lon = SNOTEL_lon(stations_ind)
    snotel_elev = SNOTEL_elev(stations_ind)
    snotel_state = SNOTEL_state(stations_ind);
    
    % Loop over stations within state
    cd /Users/zubeneschamali/Documents/Data/SNOTEL/csv
    for istation = 1:length(stations_ind)
        outname = char(sprintf(outnameSpec,SNOTEL_ID(stations_ind(istation))));
        disp(outname)
        filename = sprintf(filenameSpec,SNOTEL_ID(stations_ind(istation)));
        eval([outname '=readSNOTEL(filename)']);
    end
    
    % save all SNOTEL stations in a state in single .mat file
    cd /Users/zubeneschamali/Documents/Data/SNOTEL/mat
    fn_state = char(strcat(states(istate),'_2000_2016_SNOTEL.mat'));
    save(fn_state,'snotel_*');
    
    % clean up
    clear stations_ind snotel* fn_state
    cd /Users/zubeneschamali/Documents/Data/SNOTEL/

end









