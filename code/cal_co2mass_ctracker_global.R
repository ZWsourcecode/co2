library(ncdf4)
library(raster)
library(abind)
library(easyNCDF)

rm(list = ls())
gc()

#########################################################################
# define fuction 
#########################################################################
# grid cell area
fun_gridarea = function(lon1,lon2,lat1,lat2,R){
  s = 2*pi*(R)^2*abs(sin(pi*lat1/180)-sin(pi*lat2/180))*abs(lon1-lon2)/360
  s # return(s)
}

# flip wh dimension
fun_flipdim = function(a, wh) {
  dims = seq_len(length(dim(a)))
  dims = setdiff(dims, wh)
  apply(apply(a, dims, rev), dims, t)
}

############################################################ 
# input and output path
############################################################ 
IN_PATH = "D:/MyData/icosdata/carbontracker/monthly_global/merge/"
WDCGG_PATH = "D:/MyData/icosdata/wdcgg_glmean/wdcgg_glmean/bulletin/BY2018/data/co2/4_gl_mean/noaa/"
df_wdcgg_meta = read.csv(file = paste(WDCGG_PATH,"df_wdcgg_meta_refine.csv",sep=""),header = T)

############################################################ 
# read data
############################################################ 
ncin = nc_open(paste(IN_PATH,"CT2018_2000_2017_monthly.nc",sep = ""))
co2 = ncvar_get(ncin, "co2") # mol/mol
gc()
pressure = ncvar_get(ncin, "pressure") # Pa
gc()
gph = ncvar_get(ncin, "gph")
gph = gph[,,,1] # m
gc()

gph = aperm(gph, c(2,1,3))
gph = fun_flipdim(gph,1)

############################################################ 
# calculate co2 mass
############################################################ 

Radiu_earth = 6378.1370 # km 
Radiu_layers = gph/1000+Radiu_earth

mat_lat1 = matrix(rep(90:-89,360),nrow = 180, byrow=F)
mat_lat2 = matrix(rep(89:-90,360),nrow = 180, byrow=F)

arr_s = array(NA,c(180,360,0)) # km2
for(i in 1:dim(Radiu_layers)[3]){
  temp_s = fun_gridarea(0,1,mat_lat1,mat_lat2,Radiu_layers[,,i])
  arr_s = abind(arr_s,temp_s,along = 3)
}
arr_s = arr_s[,,1:25]

arr4d_mass_co2 = array(NA,c(180,360,25,0))
arr3d_mass_co2 = array(NA,c(180,360,0))
for(i in 1:dim(pressure)[4]){
  temp_p = pressure[,,,i]
  temp_p = aperm(temp_p, c(2,1,3))
  temp_p = fun_flipdim(temp_p,1)
  
  temp_p = apply(temp_p, c(1,2), diff)
  temp_p = aperm(temp_p, c(2,3,1))
  temp_p = abs(temp_p)
  
  temp_mass_air = temp_p*arr_s*1e6/9.81  # N/m2 * m2 /(N/kg)
  
  temp_co2 = co2[,,,i]
  temp_co2 = aperm(temp_co2, c(2,1,3))
  temp_co2 = fun_flipdim(temp_co2,1)
  
  temp4d_mass_co2 = temp_co2*44.009/28.9647*temp_mass_air # kg
  
  temp3d_mass_co2 = apply(temp4d_mass_co2, c(1,2), sum)
  
  arr4d_mass_co2 = abind(arr4d_mass_co2,temp4d_mass_co2,along = 4)
  arr3d_mass_co2 = abind(arr3d_mass_co2,temp3d_mass_co2,along = 3)
  
}
gc()

co2mass = aperm(arr3d_mass_co2/1e12, c(2,1,3)) # Gt
co2mass = fun_flipdim(co2mass,2)

metadata = list(co2mass = list(units = 'Gt(Gigatonnes)', long_name = "co2 mass")) # name here is variable name
attr(co2mass, 'variables') = metadata
names(dim(co2mass)) = c( 'lon','lat', 'time')

lon = ncvar_get(ncin, "longitude")
metadata = list(lon = list(units = 'degrees_east',axis="X"))
attr(lon, 'variables') = metadata
names(dim(lon)) = 'lon'

lat = ncvar_get(ncin, "latitude")
metadata = list(lat = list(units = 'degrees_north',axis="Y"))
attr(lat, 'variables') = metadata
names(dim(lat)) = 'lat'

time = ncvar_get(ncin, "date")
date_unit = ncatt_get(ncin, "date", "units")
metadata = list(time = list(units = date_unit$value,name="time",axis="T"))
attr(time, 'variables') = metadata

ArrayToNc(list(co2mass, lat, lon, time),file_path = paste(IN_PATH,"CT2018_2000_2017_monthly_co2mass.nc",sep = ""))


st_co2mass = stack(paste(IN_PATH,"CT2018_2000_2017_monthly_co2mass.nc",sep = ""), varname="co2mass")

df_co2mass = as.data.frame(st_co2mass,xy=T)
df_co2mass[,3:ncol(df_co2mass)] = round(df_co2mass[,3:ncol(df_co2mass)],15) # 
write.table(df_co2mass ,file = paste(IN_PATH,"CT2018_2000_2017_monthly_co2mass.txt",sep = ""),row.names = F,quote = F)

# df_co2mass = read.table(file = paste(IN_PATH,"CT2018_2000_2017_monthly_co2mass.txt",sep = ""), header = T)




