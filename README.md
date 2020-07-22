# SESYNC HEALTHY WATERSHED PROJECT 

Goal: *Add/update and evaluate a variable in the Chesapeake Healthy Watershed Assessment (CHWA).*

Variable: Percent forest cover 

Data: 

* Maryland Biological Stream Survey data attributed with numeric and categorical stream condition (point shapefile) 
* CHWA database (National Hydrologic Dataset (100K) catchments attributed with CHWA variables (CSV or polygon shapefile).  
* 2013 Tree Canopy for Maryland (1-meter raster) 

Process: 

 * Subset CHWA for Maryland 
 * Summarize (zonal) tree canopy area by NHD catchment and add/update attribute 
 * Optional-- Accumulate tree canopy area downstream (optional call to Sarah’s Python code) 
 * Add accumulate tree canopy area as a new attribute to CHWA database 
 * Relate/join MBSS point ID to NHD+ COMID 
 * Regress subset of CHWA metrics, including new one, against MBSS condition 
 * Metrics vs MBSS numeric 
 * Metrics vs MBSS categorical 
 * Visualize regression results 
 * Evaluate regression results and report pass/fail based on user  defined significance threshold 
 * If pass- commit changes to CHWA (aka NHD database), if fail- don’t commit changes to CHWA 


[CONTRIBUTING.md]: CONTRIBUTING.md

## Collaborators
- Renee Thompson, USGS
- Peter Claggett, USGS
- Sarah McDonald, USGS
- Labeeb Ahmed, Attain LLC