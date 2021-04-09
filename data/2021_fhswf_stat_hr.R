# load raw data
coursepath <- "~/sciebo/courses/bchwtz-stat"
filepath <- "nongit/data/2021-hr/HRDataset_v14.csv"
savepath <- "data"
d <- read.csv(file.path(coursepath, filepath))

# harmonize variable names
names(d) <- gsub("_","",names(d))

# export to csv
write.csv(d,
          file = file.path(coursepath,savepath,"2021_fhswf_stat_hr.csv"),
          row.names = FALSE)