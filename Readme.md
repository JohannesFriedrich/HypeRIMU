# HypeRIMU

HypeRIMU is a **R**-package for reading sensor data from the Android app [HyperIMU](https://play.google.com/store/apps/details?id=com.ianovir.hyper_imu&hl=de). 

## Installation and usage

```r
if(!require("devtools"))
  install.packages("devtools")
devtools::install_github("R-Lum/HypeRIMU@master")
```

## Related projects 

* [HIMUServer](https://github.com/ianovir/HIMUServer/)
* [HyperIMU Android](https://play.google.com/store/apps/details?id=com.ianovir.hyper_imu&hl=de)
* [Android API](https://developer.android.com/guide/topics/sensors/index.html)

## Platform tests status 
[![Build Status](https://travis-ci.org/JohannesFriedrich/HypeRIMU.svg?branch=master)](https://travis-ci.org/JohannesFriedrich/HypeRIMU)

## To Do

* support UDP stream
* make examples
* support function to get IP adress of server

## License

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  