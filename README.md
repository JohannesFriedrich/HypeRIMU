# HypeRIMU

[![Build Status](https://travis-ci.org/JohannesFriedrich/HypeRIMU.svg?branch=master)](https://travis-ci.org/JohannesFriedrich/HypeRIMU)
[![Build status](https://ci.appveyor.com/api/projects/status/lm7jn3t558yxveve?svg=true)](https://ci.appveyor.com/project/JohannesFriedrich/hyperimu)
[![Coverage Status](https://codecov.io/gh/JohannesFriedrich/HypeRIMU/branch/master/graph/badge.svg)](https://codecov.io/gh/JohannesFriedrich/HypeRIMU)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)


HypeRIMU is a **R**-package for reading sensor data from the Android app [HyperIMU](https://play.google.com/store/apps/details?id=com.ianovir.hyper_imu). 

## Installation and usage

```r
if(!require("devtools"))
  install.packages("devtools")
devtools::install_github("JohannesFriedrich/HypeRIMU@master")
```

## Examples

Create a local csv-file with the app HyperIMU and load it on your PC

```r
library("HypeRIMU")
file <- system.file('extdata', 'short_y_impulse.csv', package = 'HypeRIMU')
data <- execute_file(file, timestamp = T)
```

You can now separate different sensors (dependend on your recorded data):

```r
MPL_Accelerometer <- get_specificSensor(data, sensorName = "MPL_Accelerometer")
MPL_Linear_Acceleration <- get_specificSensor(data, sensorName = "MPL_Linear_Acceleration")
```

Plot your resuts:

```r
matplot(MPL_Accelerometer$timestamp, MPL_Accelerometer[,2:4])
```

Note that with this plot (`matplot`) the x-axis is not in a human-readable format.

We recommend using ggplot2:

```r
library(ggplot2)
library(reshape2)
library(scales)

MPL_Linear_Acceleration_melt <- melt(MPL_Linear_Acceleration, id.vars = "timestamp")

ggplot(MPL_Linear_Acceleration_melt, aes(x = timestamp, y = value, color = variable)) + 
  geom_line() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
  scale_x_datetime(labels = date_format("%H:%M:%S", tz = Sys.timezone()))
```

## Related projects 

* [HIMUServer](https://github.com/ianovir/HIMUServer/)
* [HyperIMU Android](https://play.google.com/store/apps/details?id=com.ianovir.hyper_imu)
* [Android API](https://developer.android.com/guide/topics/sensors/index.html)


## To Do

* support UDP stream
* make examples
* write function to get IP adress of server

## License

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
