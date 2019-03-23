####################################################################
#                                                                  #
# Creation date:  22/03/2019                                       #
# Author:         Sebastiano Piccolroaz (s.piccolroaz@unitn.it)    #
#                                                                  #
# Description:    This script plots the warming mosaic, a modified #                                          
#                 version of the warming stripes by Ed Hawkins,    #
#                 where monthly anomalies are plotted instead of   # 
#                 annual values.                                   #
#                 The script works with raw data downloaded from:  #
#                 http://climexp.knmi.nl/start.cgi                 #
####################################################################

# Load required libraries
library(RColorBrewer)
library(lattice)
library(grid)

# Import file
filename <- "Era20C_NHemisphere"
T <- read.table(paste0(filename,".txt"))

# year and month arrays
year <- floor(T[,1])
month <- round((T[,1]-year)*12) + 1

# temperature anomaly array
T <- T[,2]

# cut the dataset to the last year for which all months are available
n <- length(year)
ny <- n/12
ny <- floor(ny)    # number of years
n <- ny*12         # number of data
year <- year[1:n]
month <- month[1:n]
T <- T[1:n]

# create a matrix
T <- matrix(T,12,ny)
T <-t(T)

# limits
lim <- max(abs(T))
lim <- round(lim*10)/10

# color pallette
my.palette <- rev(brewer.pal(n = 11, name = "RdBu"))
my.palette = colorRampPalette(my.palette)(200)

# plot 1
png(paste0('WM_',filename,"_legend.png"),height=300, width=1000)                              
levelplot(T,col.regions=my.palette,  at=seq(-lim,lim,0.1))
dev.off()

# plot 2
png(paste0('WM_',filename,".png"),height=300, width=1000)                              
warming_mosaic <- levelplot(T,col.regions=my.palette,at=seq(-lim,lim,0.1)) 
grid.newpage() 
pushViewport(viewport(xscale = warming_mosaic$x.limits, yscale = warming_mosaic$y.limits)) 
do.call(panel.levelplot, trellis.panelArgs(warming_mosaic, 1)) 
dev.off()

# 
# 
# T <- read.csv("GLB.Ts.csv",skip = 1)
# T <- T[,2:13]
# T <- raster(t(T))
# 
# my.palette <- rev(brewer.pal(n = 10, name = "RdBu"))
# 
# plot(T, col = my.palette )
