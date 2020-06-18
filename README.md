
# CO2 analysis for the period 2000-2017 at global scale

The CO2 mole fraction records from various stations conducted by different laboratories and organizations differ in measurement period (particularly the beginning of measurement), sampling frequency (or time resolution), and gaps in measurement due to e.g. instrument malfunctions and weather conditions. However, the pattern of CO2 measurement records at locations around the globe approximately consist of three components: a long-term trend, a non-sinusoidal yearly cycle, and short term variations. According to these three characteristics, this project is going to synchronize CO2 records with a curve fitting method (NOAA method afterwards), obtained from the Global Monitoring Division (GMD) in the NOAA’s ESRL (Conway et al., 1994, Thoning et al., 1989), to depict the pattern of global CO2 mole fraction by using both station records and CarbonTracker Transport Model 5 output. This project also attempts to estimate global atmospheric CO2 mass by using global average 1x1 degree fluxes from the CarbonTracker model.

- Data
    - [CarbonTracker station data](#Carbontracker_stations_selection)
    - [CarbonTracker model data](#Carbontracker_model_data)
    - [CarbonTracker model data at WDCGG locations](#Carbontracker_model_data_WDCGG)
    - [WDCGG station data](#WDCGG_station_data)
- The curve fitting and filter method
    - [Fit to the data with a combination of polynomial and harmonic function](#curve_fit)
    
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

<a name="curve_fit"></a>
## Fit to the data with a combination of polynomial and harmonic function
CO2 records from each station can be abstracted as a combination of long-term trend and seasonality, which can be fitted by a polynomial function and Fourier harmonics, respectively. We applied the following function (Eq. 1) to fit CO2 data by using general linear least-squares fit (LFIT, Press et al. 1988).
<img src="https://bit.ly/3fCobQl" align="center" border="0" alt="f(x) =  a_{0} + a_{1}t +  x^{2} + ... +  a_{k}  t^{k}  + \sum_{n=1}^{nh} ( A_{n} cos 2 \pi nt +  B_{n} sin 2 \pi nt  ) " width="515" height="53" />


where a<sub>k</sub>, A<sub>n</sub> and B<sub>n</sub> are fitted parameters, t is the time from the beginning of the observation and it is in months and expressed as a fraction of its year. k denotes polynomial number, k=3. nh denotes harmonic number, nh=4. Figure 1 illustrates a function fit to CO2 data to gain the annual oscillation (red line in Figure 1a), is a combination of a polynomial fit to the trend (blue line in Figure 1a) and harmonic fit to the seasonality (Figure 1b). 

`#`