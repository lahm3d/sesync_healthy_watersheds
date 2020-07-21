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

# # README.md

# A `README.md` file is a very useful component of any project
# repository; it is the first file that unfamiliar users will open to
# learn about your project. If this course uses GitHub, you will also
# notice that the README.md is automatically rendered on GitHub as a
# simple "homepage" for your project. Instructions for creating your own
# GitHub repository from these files may be given during the course. The
# same instructions are also summarized in [CONTRIBUTING.md].

# ## Data
 
# If this project does not contain a data folder, the way to access data
# for the worksheets depends on whether you are using RStudio Server and
# Jupyter hosted by SESYNC or your own compute resources.

# To access the data from a SESYNC hosted environment, open RStudio and
# enter the following command at the `>` prompt.

# ```
# file.symlink('/nfs/public-data/training', 'data')
# ```

# Otherwise, download the "data.zip" folder from the course syllabus (if
# not currently there, it will be posted after the course), and unzip it
# to this "handouts" folder. The result should be a subdirectory called
# "data" within this project.

[CONTRIBUTING.md]: CONTRIBUTING.md

## Collaborators

- Labeeb Ahmed