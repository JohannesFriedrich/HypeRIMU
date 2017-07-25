## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, fig.align = "center")

## ------------------------------------------------------------------------
library(HypeRIMU)
data <- execute_file(filepath = "~/Schreibtisch/temp/HIMU/short_y_impulse.csv", timestamp = T)

head(data[,1:4])

## ---- eval=FALSE---------------------------------------------------------
#  data <- execute_TCP(port = 5555, timestamp = T)

## ------------------------------------------------------------------------
MPL_Accelerometer <- get_specificSensor(data, sensorName = "MPL_Accelerometer")

MPL_Linear_Acceleration <- get_specificSensor(data, sensorName = "MPL_Linear_Acceleration")

## ----plot sensor data----------------------------------------------------
library(ggplot2)
library(reshape2)
library(scales)

MPL_Linear_Acceleration_melt <- melt(MPL_Linear_Acceleration, id.vars = "timestamp")

ggplot(MPL_Linear_Acceleration_melt, aes(x = timestamp, y = value, color = variable)) + 
  geom_line() +
  scale_x_datetime(labels = date_format("%H:%M:%S")) +
  theme(legend.position = "bottom")


## ------------------------------------------------------------------------

MPL_Accelerometer_melt <- melt(MPL_Accelerometer, id.vars = "timestamp")

ggplot(MPL_Accelerometer_melt, aes(x = timestamp, y = value, color = variable)) + 
  geom_line() +
  scale_x_datetime(labels = date_format("%H:%M:%S"))+
  theme(legend.position = "bottom")

