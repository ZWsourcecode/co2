
# CO2 analysis for the period 2000-2017 at global scale

This project analyzes monthly observation data (2000-2016) and simulation data (2000-2017) from CarbonTracker Transport Model 5 and attempt to estimate global mean CO2 mole fraction and atmospheric CO2 mass.

- Data
    - [CarbonTracker station data](#Carbontracker_stations_selection)
    - [CarbonTracker model data](#Carbontracker_model_data)
    - [CarbonTracker model data at WDCGG locations](#Carbontracker_model_data_WDCGG)
    - [WDCGG station data](#WDCGG_station_data)

<a name="Carbontracker_station_data"></a>
## CarbonTracker station data
The observed CO2 mole fraction is derived from 185 out of 246 global-wide distributed stations, which include surface-based, shipboard-based and tower-based measurements. The original data are in NetCDF format and have been converted to txt format. The key information of each file can be found in [df_meta_selected_ctracker_update.csv](/data/ctracker_obs/df_meta_selected_ctracker_update.csv). The data can be found in [ctracker_obs/input](/data/ctracker_obs/input) (There are only two txt files uploaded due to limitation of space). 

<a name="Carbontracker_model_data"></a>
## CarbonTracker model data
CarbonTracker simulated CO2 mole fraction with 1x1 degree resolution and 25 levels in the vertical. The vertical level 1 data is used to estimate global CO2 mole fraction. The full layers data are used to calculate atmospheric CO2 mass. The data can be found in [ctracker_model/inputglobal](/data/ctracker_model/inputglobal). More information about data can be found in [CarbonTracker Europe](https://www.carbontracker.eu/).

<a name="Carbontracker_model_data_WDCGG"></a>
## CarbonTracker model data at WDCGG locations
Extract CarbonTracker model output at the location of WDCGG's 129 stations. CarbonTracker data at multiple levels will be used, basing on the altitude of measurement is taken at each WDCGG station. The data can be found in [ctracker_model/input129](/data/ctracker_model/input129).

<a name="WDCGG_station_data"></a>
## WDCGG station data
The raw monthly data from the World Data Center for Greenhouse Gases (WDCGG)'s 129 stations is located in [wdcgg_obs/input](/data/wdcgg_obs/input). The output from global analysis by WDCGG are used to evaluate CarbonTracker model outputs. The data is got from [Mikio UENO](https://community.wmo.int/contacts/dr-mikio-ueno) can be found in [wdcgg_obs/outputMikio](/data/wdcgg_obs/outputMikio).
The location of selected 185 observation stations from CarbonTracker project (<font color=red>red dots</font>) and the 129 stations used in WDCGG analysis (<font color=blue>blue triangles</font>)  (Tsutsumi et al., 2009), shown as bellow.
![measurement location](/images/observation_location.png)

