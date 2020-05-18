# install.packages("readtext")
# library(readtext)

rm(list = ls())
gc()

pre_path = "/media/zhendong/st128m4t/icos/carbontracker/data/mole_fractions/"

out_path = "/media/zhendong/st128m4t/icos/carbontracker/data/"
# out_path = "D:/MyData/icosdata/carbontracker/"


filenames = dir(pre_path)
############# stations selection ############# 
split_underline = strsplit(filenames,"_",fix=T)
# ncomponents = unlist(lapply(split_underline, function(x){length(x)}))
# max(ncomponents)
df_filenames = data.frame(matrix(ncol = 0, nrow = length(filenames)))
df_filenames$gas = unlist(lapply(split_underline, function(x){x[1]}))
df_filenames$station = unlist(lapply(split_underline, function(x){x[2]}))
df_filenames$measurement = unlist(lapply(split_underline, function(x){x[3]}))
df_filenames$number = unlist(lapply(split_underline, function(x){x[4]}))
df_filenames$sample = unlist(lapply(split_underline, function(x){x[5]}))
df_filenames$extension = unlist(lapply(split_underline, function(x){x[6]}))

split_dot = strsplit(df_filenames$sample,".",fix=T)
df_filenames$sample = unlist(lapply(split_dot, function(x){x[1]}))
df_filenames$extension[is.na(df_filenames$extension)] = ".nc"
# table(df_filenames[,c(3,5,6)])


if (!file.exists(out_path)){
  dir.create(file.path(out_path), showWarnings = F, recursive = T)
  # dir.create(file.path(mainDir, subDir))
}
write.csv(df_filenames, file = paste(out_path,"df_filenames_ctracker.csv",sep = ""))




######## select data ########

# select sample interval / period
select_fun = function(temp, iftower){
  condition = grepl("allvalid", temp$sample, ignore.case = T) & temp$extension==".nc"
  temp_allvalid = temp[condition,]
  if(nrow(temp_allvalid)){
    if(iftower){
      towerheight = as.numeric(gsub("[^0-9]","",temp_allvalid$sample))
      if(length(towerheight)==1){
        temp_select =temp_allvalid
      }else{
        temp_select =temp_allvalid[which.max(towerheight),]
      }
    }else{
      temp_select = temp_allvalid[which.max(temp_allvalid$number),]
    }
    return(temp_select) 
  }
  
  condition = grepl("representative", temp$sample, ignore.case = T) & temp$extension==".nc"
  temp_representative = temp[condition,]
  if(nrow(temp_representative)){
    if(iftower){
      towerheight = as.numeric(gsub("[^0-9]","",temp_representative$sample))
      if(length(towerheight)==1){
        temp_select =temp_representative
      }else{
        temp_select =temp_representative[which.max(towerheight),]
      }
    }else{
      temp_select = temp_representative[which.max(temp_representative$number),]
    }
    return(temp_select) 
  }
  
  condition = grepl("allhours", temp$sample, ignore.case = T) & temp$extension==".nc"
  temp_allhours = temp[condition,]
  if(nrow(temp_allhours)){
    if(iftower){
      towerheight = as.numeric(gsub("[^0-9]","",temp_allhours$sample))
      if(length(towerheight)==1){
        temp_select =temp_allhours
      }else{
        temp_select =temp_allhours[which.max(towerheight),]
      }
    }else{
      temp_select = temp_allhours[which.max(temp_allhours$number),]
    }
    return(temp_select) 
  }
  
  condition = grepl("marine", temp$sample, ignore.case = T) & temp$extension==".nc"
  temp_marine = temp[condition,]
  if(nrow(temp_marine)){
    if(iftower){
      towerheight = as.numeric(gsub("[^0-9]","",temp_marine$sample))
      if(length(towerheight)==1){
        temp_select =temp_marine
      }else{
        temp_select =temp_marine[which.max(towerheight),]
      }
    }else{
      temp_select = temp_marine[which.max(temp_marine$number),]
    }
    return(temp_select) 
  }
  
  condition = grepl("nonlocal", temp$sample, ignore.case = T) & temp$extension==".nc"
  temp_nonlocal = temp[condition,]
  if(nrow(temp_nonlocal)){
    if(iftower){
      towerheight = as.numeric(gsub("[^0-9]","",temp_nonlocal$sample))
      if(length(towerheight)==1){
        temp_select =temp_nonlocal
      }else{
        temp_select =temp_nonlocal[which.max(towerheight),]
      }
    }else{
      temp_select = temp_nonlocal[which.max(temp_nonlocal$number),]
    }
    return(temp_select) 
  }
}


select_path = "/media/zhendong/st128m4t/icos/carbontracker/data/selected/"
# select_path = "D:/MyData/icosdata/carbontracker/"
if (!file.exists(select_path)){
  dir.create(file.path(select_path), showWarnings = F, recursive = T)
  # dir.create(file.path(mainDir, subDir))
}

df_filenames = read.csv(file = paste(out_path,"df_filenames.csv",sep = ""))
df_filenames = df_filenames[,2:ncol(df_filenames)]
# table(df_filenames[,3])
# table(df_filenames[,5])
# table(df_filenames[,6])
# df_surface = df_filenames[grepl("surface", df_filenames$measurement, ignore.case = T),]
# length(unique(df_surface$station))
# df_aircraft = df_filenames[grepl("aircraft", df_filenames$measurement, ignore.case = T),]
# length(unique(df_aircraft$station))
# df_shipboard = df_filenames[grepl("shipboard", df_filenames$measurement, ignore.case = T),]
# length(unique(df_shipboard$station))
# df_tower = df_filenames[grepl("tower", df_filenames$measurement, ignore.case = T),]
# length(unique(df_tower$station))

station = unique(df_filenames$station)  # 246
vec_selectedfile = c()
for(i in 1:length(station)){
  # i=57 
  temp = df_filenames[which(df_filenames$station==station[i]),]
  
  temp_surface = temp[grepl("surface", temp$measurement, ignore.case = T),]
  temp_shipboard = temp[grepl("shipboard", temp$measurement, ignore.case = T),]
  temp_tower = temp[grepl("tower", temp$measurement, ignore.case = T),]
  
  temp_select = c()
  if(nrow(temp_surface)){
    temp_select = select_fun(temp_surface, 0)
  }else if(nrow(temp_shipboard)){
    temp_select = select_fun(temp_shipboard, 0)
  }else if(nrow(temp_tower)){
    temp_select = select_fun(temp_tower, 1)
  }

  if (length(temp_select)) {
    file_select = paste(temp_select[1,1],"_",temp_select[1,2],"_",
                        temp_select[1,3],"_",temp_select[1,4],"_",
                        temp_select[1,5],temp_select[1,6],sep = "") 
    system(paste('cp ', pre_path, file_select," ", select_path, sep = "" ), wait = TRUE)
    vec_selectedfile = rbind(vec_selectedfile,file_select)
  }

}
write.csv(vec_selectedfile, file = paste(select_path,"df_selectedfile_ctracker.csv",sep = ""))








