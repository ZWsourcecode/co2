
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

***Fig.1***
![measurement location](/images/observation_location.png)

<a name="curve_fit"></a>
# 2.The curve fitting and filter method
The fitting and filter method from NOAA ESRL is applied to the data mentioned in [section 1](#Carbontracker_station_data), here is the [Python code](/code/fit_filter_noaa.ipynb)
## 2.1. Fit to the data with a combination of polynomial and harmonic function
CO2 records from each station can be abstracted as a combination of long-term trend and seasonality, which can be fitted by a polynomial function and Fourier harmonics, respectively. We applied the following function (Eq. 1) to fit CO2 data by using general linear least-squares fit (LFIT, Press et al. 1988).

***Eq.1  :***

![](http://www.sciweavers.org/upload/Tex2Img_1592493141/render.png)  

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
The growth rate is determined by taking the first derivative of the long-term trend. However the trend is made up of discrete points than in a functional form, e.g. the black dots in Fig. 3a shows the trend points. In this case, an cubic spline interpolation is applied to the trend points, in which the spline curve passes through each trend points, as the blue line in fig. 3a. The CO2 growth rate is obtained with the derivative of the spline at each trend point.

***Fig.3***
![figure 3](/images/figure3.png)
