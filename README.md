
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
    - [3.1. Integrate zonal and global mean CO2](#Integrate_mean)
    - [3.2. Compare zonal and global mean CO2](#Compare_mean)
- 4.Global atmospheric CO2 mass
    - [4.1. CO2 mass calculation](#mass_calculation)
    - [4.2. Zonal and global CO2 mass](#plot_mass)
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
<a name="Integrate_mean"></a>
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

<a name="Compare_mean"></a>
## 3.2. Compare zonal and global mean CO2 [[Python code]](/code/compare_wdcgg_ctracker_obs.ipynb)
- a. The NOAA method applied to different data sources (CarbonTracker observation and WDCGG observation) in 49 common stations, 2000-2017.

    Fig.7. shows the difference (CarbonTracker-WDCGG) in CO2 global mean monthly mole fraction. The global mean is derived from 49 common stations see Fig.1. The CarbonTracker (observations) global mean is, on average, **0.059±0.319** ppm smaller than that of the WDCGG (Fig.7b). Seasonally, CarbonTracker values has larger seasonality than the WDCGG, i.e. CarbonTracker observation value have smaller in summer and higher in the other seasons. The potential causes for these discrepancies are the different data used in the stations (Fig.7a) (e.g. different dates and period of collections, different validations applied). The CarbonTracker (observations) growth rate is **0.044±0.180** ppm / year slower than that of the WDCGG (Fig.7c).

    ***Fig.7. The difference in global, NH and SH area-weighted average CO2 concentration, (CarbonTracker observation-WDCGG observation).***
    *Penal a shows the difference of raw data. Penal b shows the difference after applying NOAA method. Penal c shows the difference in growth rate*
    ![figure 7](/images/figure7.png)
- b. The NOAA method applied to different data sources (CarbonTracker model and WDCGG observation) in 129 common stations, 2000-2017.

    Fig.8. shows the difference (CarbonTracker-WDCGG) in CO2 global mean monthly mole fraction. The global mean is derived from CarbonTracker model output and the WDCGG stations at 129 locations see Fig.1. The CarbonTracker (model) global mean is, on average, **0.685±0.298** ppm larger than that of the WDCGG (Fig.8b). Seasonally, CarbonTracker values has larger seasonality than the WDCGG, i.e. CarbonTracker observation value have smaller in summer and higher in the other seasons. The potential causes for these discrepancies are the different data source (Fig.8a), (one is from model, the other is from observation). The CarbonTracker (model) growth rate is **0.009±0.195** ppm / year faster than that of the WDCGG (Fig.8c).
    
    ***Fig.8. The difference in global, NH and SH area-weighted average CO2 concentration, (CarbonTracker model-WDCGG observation).***
    *Penal a shows the difference of raw data. Penal b shows the difference after applying NOAA method. Penal c shows the difference in growth rate*
    ![figure 8](/images/figure8.png)
    
- c. The different methods (NOAA and Mikio) applied to the WDCGG observation at 129 stations, 1968-2017
   
    Fig.9. shows the difference effect of two fit and filter methods (NOAA-Mikio) on CO2 global mean monthly mole fraction. The global mean is derived from the observation of 129 WDCGG stations see Fig.1. The global mean from NOAA method is, on average, **0.0015±0.1671** ppm smaller than that of the WDCGG (Fig.9a). The NOAA method growth rate is **0.0001±0.1177** ppm / year faster than that of the WDCGG (Fig.9b). The result indicates the method NOAA and Mikio work similarly when it comes to calculate global mean and growth rate. 
    
    ***Fig.9. The difference in global, NH and SH area-weighted average CO2 concentration, (CarbonTracker model-WDCGG observation).***
    *Penal a shows the difference of raw data. Penal b shows the difference after applying NOAA method. Penal c shows the difference in growth rate*
    ![figure 9](/images/figure9.png)
- d. The different methods (NOAA and Mikio) applied to the different data sources (CarbonTracker model and WDCGG observation), 2000-2017
    
    Fig.10. shows the difference (CarbonTracker model NOAA - WDCGG observation Mikio) in CO2 global mean monthly mole fraction. The global mean is derived from CarbonTracker model output and the WDCGG stations at 129 locations see Fig.1. The CarbonTracker model NOAA global mean is, on average, **0.666±0.313** ppm larger than that of the WDCGG observation Mikio (Fig.10b). Seasonally, CarbonTracker values has larger seasonality than the WDCGG, i.e. CarbonTracker observation value have smaller in summer and higher in the other seasons. The potential causes for these discrepancies are the different data source (Fig.10a), (one is from model, the other is from observation). The CarbonTracker (model) growth rate is **0.018±0.193** ppm / year faster than that of the WDCGG (Fig.10c).
    
    ***Fig.10. The difference in global, NH and SH area-weighted average CO2 concentration, (CarbonTracker model NOAA - WDCGG observation Mikio).***
    *Penal a shows the difference of raw data. Penal b shows the difference after applying fit and filter method. Penal c shows the difference in growth rate*
    ![figure 10](/images/figure10.png)

# 4. Global atmospheric CO2 mass
<a name="mass_calculation"></a>
## 4.1. CO2 mass calculation [[Python code]](/code/cal_co2mass_ctracker_global.ipynb)
***Fig.11. Illustration of the estimation of global CO2 mass at the atmosphere. Left drawing visualizes the structure of CarbonTracker model outputs, CO2 concertation at different level (level 1-25), air pressure (p 1-26), and geopotential height refers to Earth's mean sea level (gph 1-26). Right drawing visualizes the area of a grid cell at different gph and the volume of the air at different level.***
![figure 11](/images/figure11.png)
CarbonTracker model defined 25 levels of atmosphere (Fig.11). The CO2 mass at each level of the atmosphere can be calculated as a function of air mass and CO2 concentration by weight (Eq.2). 

***Eq.2:***

![Eq.2](/images/Eq2.png)

where m<sub>CO2</sub> is the mass of the CO2, kg. Cw<sub>CO2</sub> is CO2 concentration by weight, w %. m<sub>air</sub> is the mass of the air, kg. CO2 concentration by weight is obtained by the formula below:

***Eq.3:***

![Eq.3](/images/Eq3.png)

where Cv<sub>CO2</sub> is mole fraction of CO2 in air, mol / mol. According to the ideal gas assumption, equal volume of gases at same temperature and pressure contain equal number of moles regardless of chemical nature of gases, i.e. CO2 concentration by mole equals CO2 concentration by volume. M<sub>CO2</sub> is CO2 molar mass (44.009 g/mol). M<sub>air</sub> is the average molar mass of dry air (28.9647 g / mol).

Pressure is the force applied perpendicular to the surface of an object, therefore, air pressure can be expressed by: 

***Eq.4:***

![Eq.4](/images/Eq4.png)

where p<sub>air</sub> is the pressure of air, Pa or N / m2. In this case, p<sub>air</sub> is the difference of air pressure between adjacent level boundaries, e.g. air pressure at level 1 is p<sub>1</sub>-p<sub>2</sub> (Fig.11). F<sub>air</sub> is the magnitude of the normal force of air or gravity of air, N or kg m / s². The gravity of air at each level can be estimated by:

***Eq.5:***

![Eq.5](/images/Eq5.png)

where g is the gravitational field strength, about 9.81 m / s2 or N / kg.
S is the area of the surface, m2. Here S is the area of grid cell at each level, increasing with geopotential height (gph). It is calculated as a function of latitude and longitude on earth's surface, radius of the earth (R), and gph.  

***Eq.6:***

![Eq.6](/images/Eq6.png)

Where, lat<sub>1</sub>, lat<sub>2</sub>, lon<sub>1</sub> and lon<sub>2</sub> are the boundary of grid cell. R = 6378.1370 km, here we use the equatorial radius which is the distance from earth’s center to the equator.
Hence the mass of the air in Eq. 2 can be estimated by:

***Eq.7:***

![Eq.7](/images/Eq7.png)

<a name="plot_mass"></a>
## 4.2. Zonal and global CO2 mass [[Python code]](/code/plot_co2mass.ipynb)
***Fig.12. Global, NH and SH CO2 mass from surface to 200000m.***
*Penal a shows the global CO2 mass. Penal b shows the Northern Hemisphere CO2 mass. Penal c shows the Southern Hemisphere CO2 mass*
![figure 12](/images/figure12.png)

***Fig.13. CO2 mass zonal map.***
![figure 13](/images/figure13.png)

