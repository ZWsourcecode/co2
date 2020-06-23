
# Global CO2 analysis for the period 2000-2017

The CO2 mole fraction records from various stations conducted by different laboratories and organizations differ in measurement period (particularly the beginning of measurement), sampling frequency (or time resolution), and gaps in measurement due to e.g. instrument malfunctions and weather conditions. However, the pattern of CO2 measurement records at locations around the globe approximately consist of three components: a long-term trend, a non-sinusoidal yearly cycle, and short term variations. According to these three characteristics, this project is going to synchronize CO2 records with a curve fitting method (NOAA method afterwards), obtained from the Global Monitoring Division (GMD) in the NOAA’s ESRL (Conway et al., 1994, Thoning et al., 1989), to depict the pattern of global CO2 mole fraction by using both station records and CarbonTracker Transport Model 5 output. This project also attempts to estimate global atmospheric CO2 mass by using global average 1x1 degree fluxes from the CarbonTracker model.

- 1.Data
    - [1.1. CarbonTracker station data](#Carbontracker_stations_selection)
    - [1.2. CarbonTracker model data](#Carbontracker_model_data)
    - [1.3. CarbonTracker model data at WDCGG locations](#Carbontracker_model_data_WDCGG)
    - [1.4. WDCGG station data](#WDCGG_station_data)
- 2.The curve fitting and filter method
    - [2.1. Fit to the data with a combination of polynomial and harmonic function](#curve_fit)
    - [2.2. Filtering of residuals](#filter_residuals)
    - [2.3. Gain smoothed CO2 and long-term growth](#smoothed_co2)
    - [2.4. CO2 growth rate](#growth_rate)
- 3.Zonal and global mean CO2 mole fraction
    
- 4.Global atmospheric CO2 mass
    
<a name="Carbontracker_station_data"></a>
# 1. Data
## 1.1. CarbonTracker station data
The observed CO2 mole fraction is derived from 185 out of 246 global-wide distributed stations, which include surface-based, shipboard-based and tower-based measurements. The original data are in NetCDF format and have been converted to txt format. The key information of each file can be found in [df_meta_selected_ctracker_update.csv](/data/ctracker_obs/df_meta_selected_ctracker_update.csv). The data can be found in [ctracker_obs/input](/data/ctracker_obs/input) (There are only two txt files uploaded due to limitation of space). 

<a name="Carbontracker_model_data"></a>
## 1.2. CarbonTracker model data
CarbonTracker simulated CO2 mole fraction with 1x1 degree resolution and 25 levels in the vertical. The vertical level 1 data is used to estimate global CO2 mole fraction. The full layers data are used to calculate atmospheric CO2 mass. The data can be found in [ctracker_model/inputglobal](/data/ctracker_model/inputglobal). More information about data can be found in [CarbonTracker Europe](https://www.carbontracker.eu/).

<a name="Carbontracker_model_data_WDCGG"></a>
## 1.3. CarbonTracker model data at WDCGG locations
Extract CarbonTracker model output at the location of WDCGG's 129 stations. CarbonTracker data at multiple levels will be used, basing on the altitude of measurement is taken at each WDCGG station. The data can be found in [ctracker_model/input129](/data/ctracker_model/input129).

<a name="WDCGG_station_data"></a>
## 1.4. WDCGG station data
The raw monthly data from the World Data Center for Greenhouse Gases (WDCGG)'s 129 stations is located in [wdcgg_obs/input](/data/wdcgg_obs/input). The output from global analysis by WDCGG are used to evaluate CarbonTracker model outputs. The data is got from [Mikio UENO](https://community.wmo.int/contacts/dr-mikio-ueno) can be found in [wdcgg_obs/outputMikio](/data/wdcgg_obs/outputMikio).
The location of selected 185 observation stations from CarbonTracker project (<font color=red>red dots</font>) and the 129 stations used in WDCGG analysis (<font color=blue>blue triangles</font>)  (Tsutsumi et al., 2009), shown as bellow (Fig. 1).

![measurement location](/images/observation_location.png)
***Fig.1. Global locations of the selected 185 CarbonTracker observation stations (red dots) and the 129 stations used in WDCGG analysis (Tsutsumi et al., 2009)***

<a name="curve_fit"></a>
# 2.The curve fitting and filter method [[Python code]](/code/fit_filter_noaa.ipynb)
The fitting and filter method from NOAA ESRL is applied to the data mentioned in [section 1](#Carbontracker_station_data).
## 2.1. Fit to the data with a combination of polynomial and harmonic function
CO2 records from each station can be abstracted as a combination of long-term trend and seasonality, which can be fitted by a polynomial function and Fourier harmonics, respectively. We applied the following function (Eq. 1) to fit CO2 data by using general linear least-squares fit (LFIT, Press et al. 1988).

***Eq.1  :***

![Eq. 1](/images/Eq1.png)  

where a<sub>k</sub>, A<sub>n</sub> and B<sub>n</sub> are fitted parameters, t is the time from the beginning of the observation and it is in months and expressed as a fraction of its year. k denotes polynomial number, k=3. nh denotes harmonic number, nh=4. Fig. 2 illustrates a function fit to CO2 data at AAC station to gain the annual oscillation (red line in Fig 2a), is a combination of a polynomial fit to the trend (blue line in Fig. 2a) and harmonic fit to the seasonality (green line in Fig. 2b). 

***Fig.2***
![figure 2](/images/figure2.png)

<a name="filter_residuals"></a>
## 2.2. Filtering of residuals
The residuals is difference between raw data and the function fit (black dots in Fig. 2c). The filtering method is obtained from Thoning et al., (1989), which transforms CO2 data from time domain to frequency domain by using Fast Fourier Transform (FFT), apply a low pass filter to the frequency data to remove high-frequency variations, then transform the filtered data back to the time domain using an inverse FFT. Two filters, short term (a cut-off frequency of 4.5625 cycles/year, red line in Fig. 2c) and long term (a cut-off frequency of 0.5472 cycles/year, blue line in Fig. 2c), are applied in order to obtain the short term and interannual variations that are not determined by the fit function.

<a name="smoothed_co2"></a>
## 2.3. Gain smoothed CO2 and long-term growth  
The results of the filtering residuals are then added to the fitted curve to obtain smoothed CO2 and its long-term growth. The smoothed CO2 comprises fitted trend, fitted seasonality and smoothed residuals (red line in Fig. 2d), which only removes short-term variations or noise. The long-term growth comprises fitted trend and residual trend, which removes seasonal cycle and noise (blue line in Fig. 2d).

<a name="growth_rate"></a>
## 2.4. CO2 growth rate
The growth rate is determined by taking the first derivative of the long-term trend. However the trend is made up of discrete points than in a functional form, e.g. the black dots in Fig. 3a shows the trend points. In this case, an cubic spline interpolation is applied to the trend points, in which the spline curve passes through each trend points, as the blue line in fig. 3a. The CO2 growth rate is obtained with the derivative of the spline at each trend point (Fig. 3b).

***Fig.3***
![figure 3](/images/figure3.png)

# 3. Zonal and global mean CO2 mole fraction
## 3.1 Integrate zonal and global mean CO2
Zonal means of CO2 mole fraction (each 30° , suggested by Tsutsumi et al., 2009) are calculated using observations from stations or outputs from CarbonTracker model located in each latitudinal band. Global and hemispheric means are calculated by area-weighted averaging the zonal means over each latitudinal band. Here we calculates five sets of zonal and global CO2 mole fraction basing on the five different data sets.
- a. CarbonTracker observation data, 185 stations, 2000-2017, NOAA method [[Python code]](/codes/cal_zonal_global_co2_ctracker_obs.ipynb)
- b. CarbonTracker model output, 129 grids as the same locations of WDCGG observations, 2000-2017, NOAA method [[Python code]](/codes/cal_zonal_global_co2_ctracker_model_129p.ipynb)
- c. CarbonTracker model output, full global grids, 2000-2017, NOAA method [[Python code]](/codes/cal_zonal_global_co2_ctracker_model_global.ipynb)
- d. WDCGG observations, 129 stations, 1968-2017, NOAA method [[Python code]](/codes/cal_zonal_global_co2_wdcgg_noaa.ipynb)
- e. WDCGG observations, 129 stations, 2000-2017, NOAA method [[Python code]](/codes/cal_zonal_global_co2_wdcgg_noaa_from2000.ipynb)
- f. WDCGG observations, 129 stations, 1968-2017, Mikio method [[Python code]](/codes/cal_zonal_global_co2_wdcgg_mikio.ipynb)

Here shows an example of zonal and global mean CO2 mole fraction basing on CarbonTracker observation data. The rest results can be found in the `python code` (Jupyter notebook) mentioned above. 

***Fig.4. An example (CarbonTracker observation) of global, NH and SH area-weighted average CO2 mole fraction.***
*Penal a shows the CO2 mole fraction derived from raw data. Penal b shows the CO2 mole fraction by applying NOAA method. Penal c shows the difference between raw and calculated data*
![figure 4](/images/figure4.png)

***Fig.5. An example (CarbonTracker observation) of CO2 zonal map, 5° per band.***
*Penal a shows the CO2 mole fraction derived from raw data. Penal b shows the CO2 mole fraction by applying NOAA method.*
![figure 5](/images/figure5.png)

***Fig.6. An example (CarbonTracker observation) of global, NH and SH area-weighted average CO2 growth rate.***
*Penal a shows the CO2 mole fraction growth rate after applying NOAA method.*
![figure 6](/images/figure6.png)

## 3.2. Compare zonal and global mean CO2 [[Python code]](/code/compare_wdcgg_ctracker_obs.ipynb)
- a. The NOAA method applied to different data sources (ctracker observation and wdcgg observation) in 49 common stations, 2000-2017.

    Fig.7. shows the difference (CarbonTracker-WDCGG) in CO2 global mean monthly mole fraction. The global mean is derived from 49 common stations see Fig.1. The CarbonTracker (observations) global mean is, on average, **0.059±0.319** ppm smaller than that of the WDCGG (Fig.7b). Seasonally, CarbonTracker values has larger seasonality than the WDCGG, i.e. CarbonTracker observation value have smaller in summer and higher in the other seasons. The potential causes for these discrepancies are the different data used in the stations (Fig.7a) (e.g. different dates and period of collections, different validations applied). The CarbonTracker (observations) growth rate is **0.044±0.180** ppm / year slower than that of the WDCGG (Fig.7c).

    ***Fig.7. The difference in global, NH and SH area-weighted average CO2 concentration, (CarbonTracker observation-WDCGG observation).***
    *Penal a shows the difference of raw data. Penal b shows the difference after applying NOAA method. Penal c shows the difference in growth rate*
    ![figure 7](/images/figure7.png)
- b. The NOAA method applied to different data sources (ctracker model and wdcgg observation) in 129 common stations, 2000-2017.

    Fig.8. shows the difference (CarbonTracker-WDCGG) in CO2 global mean monthly mole fraction. The global mean is derived from CarbonTracker model output and the WDCGG stations at 129 locations see Fig.1. The CarbonTracker (model) global mean is, on average, **0.685±0.298** ppm larger than that of the WDCGG (Fig.8b). Seasonally, CarbonTracker values has larger seasonality than the WDCGG, i.e. CarbonTracker observation value have smaller in summer and higher in the other seasons. The potential causes for these discrepancies are the different data source (Fig.8a), (one is from model, the other is from observation). The CarbonTracker (model) growth rate is **0.009±0.195** ppm / year faster than that of the WDCGG (Fig.8c).
    
    ***Fig.8. The difference in global, NH and SH area-weighted average CO2 concentration, (CarbonTracker model-WDCGG observation).***
    *Penal a shows the difference of raw data. Penal b shows the difference after applying NOAA method. Penal c shows the difference in growth rate*
    ![figure 8](/images/figure8.png)