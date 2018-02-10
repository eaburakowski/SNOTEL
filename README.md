# SNOTEL
matlab scripts used for processing snotel data. Code requires customization and will not run 'as-is'.  Always happy to answer questions and I welcome helpful suggestions to improve the efficiency of the code.  This code was written for a specific project (TBA at a later date) and is adaptable for multiple uses. elizabeth.burakowski@unh.edu.

Files listed in order of use in my processeing & analysis.

(1) SNOTEL data retrieved using khufkens/snotelr R package:
https://github.com/khufkens/snotelr
- requires the user to generate a list of desired SNOTEL stations from:
https://wcc.sc.egov.usda.gov/nwcc/inventory
- save the inventory file as SNOTEL_Inventory_wHeaders.csv

(2) importSNOTEL_inv.m
- imports the snotel inventory file, SNOTEL_Inventory_wHeaders.csv
- this script is used in the loadSNOTEL.m script below, it is not meant to run stand-alone

(3) readSNOTEL.m
- reads the snotel individual station data, "snotel_XXXX.csv", where XXXX is the station number
- this script is used in the loadSNOTEL.m script below, it is not meant to run stand-alone

(4) loadSNOTEL.m
- loads snotel station data and saves in state-level .mat files

(5) procSNOTEL_SWE.m
- calculates percent missing data per winter
- removes years missing >25% of daily records
- removes stations missing > 2 years of data 
- calculates station total SWE (integrated under season curve; SWEsum) for each year
- calculates station maximum SWE (SWEmax) for each year
- calculates the state average total SWEsum for each year
- calculates the state average maximum SWE (SWEmax) for each year
- ranks the winters from highest to lowest based on SWEsum and SWEmax
- plots time series of state-level SWEsum and SWEmax in double-y axis plot
