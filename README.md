
# CO2 analysis for the period 2000-2017 at global scale

This project analyzes monthly observation data (2000-2016) and simulation data (2000-2017) from CarbonTracker Transport Model 5 and attempt to estimate global mean CO2 mole fraction and atmospheric CO2 mass.

- Data
    - [Carbontracker station data](#Carbontracker_stations_selection)
    - [Carbontracker model data](#Carbontracker_model_data)
    - [Carbontracker model data at WDCGG locations](#Carbontracker_model_data_WDCGG)
    - [WDCGG station data](#WDCGG_station_data)

<a name="Carbontracker_station_data"></a>
## Carbontracker station data
The observed CO2 mole fraction is derived from 185 out of 246 global-wide distributed stations, which include surface-based, shipboard-based and tower-based measurements. The original data are in NetCDF format and have been converted to txt format. (the key information of each file can be found in df_meta_selected_ctracker_update.csv under [ctracker_obs](/output/ctracker_obs), the txt format files can be found in [ctracker_obs/input](/output/ctracker_obs)) 

<a name="Carbontracker_model_data"></a>
## Carbontracker model data
CarbonTracker simulated CO2 mole fraction with 1x1 degree resolution and 25 levels in the vertical. The vertical level 1 data is used to estimate global CO2 mole fraction. The full layers data are used to calculate atmospheric CO2 mass. More information about data can be found in [CarbonTracker Europe](https://www.carbontracker.eu/).

<a name="Carbontracker_model_data_WDCGG"></a>
## Carbontracker model data at WDCGG locations
Extract carbontracker model output at the location of WDCGG's 129 stations. Carbontracker data at multiple levels will be used, base on the altitude of measurement is taken at each WDCGG station.

<a name="WDCGG_station_data"></a>
## WDCGG station data
The monthly data from WDCGG's 129 stations are used to evaluate Carbontracker model outputs. 
Global locations of selected 186 observation stations within CarbonTracker project (<font color=red>red dots</font>) and the 129 stations used in WDCGG analysis (<font color=blue>blue triangles</font>)  (Tsutsumi et al., 2009), shown as bellow.
![measurement location](/images/observation_location.png)

