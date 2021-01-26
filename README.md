![alt text](https://im.ezgif.com/tmp/ezgif-1-a37470a31088.gif)
# Aircraft 3D Animation Function
![GitHub](https://img.shields.io/github/license/Ro3code/aircraft_3d_animation) ![GitHub all releases](https://img.shields.io/github/downloads/Ro3code/aircraft_3d_animation/total) [![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger) ![GitHub top language](https://img.shields.io/github/languages/top/Ro3code/aircraft_3d_animation)

A lightweight MATLAB(R) function to easily visualize flight test data recordings and outputs of nonlinar flight dynamics simulators. To download the official releases and rate `aircraft_3d_animation` function, please visit its page on [FileExchange](http://www.mathworks.com/matlabcentral/fileexchange/22022).

Features
============
* Selectable maneuvre reproduction speed 
* Export maneuvre animation to an MP4 video file
* Highly customizable for other aircraft 3D model

Installation
============

1. Extract the ZIP file (or clone the git repository) somewhere you can easily reach it. 
2. Add the `src/` folder to your path in MATLAB: e.g. 
    - using the "Set Path" dialog in MATLAB, or 
    - by running the `addpath` function from your command window or `startup` script.
    
Usage
=====

Just feed your flight test or simulation data to the function as follows:

```matlab

```

Using an Ad-Hoc Aircraft 3D Model
=================================

The first thing you will need to do is to look for is a 3D model in *.stl format (STereoLithography) that best represents the external geometry of the plane or air vehicle.

There is a wide variety of web pages where you can find an infinity of 3D models to download for free. I recommend you to have a look at the following websites where you will surely find the 3D model you are looking for:

* 
*

You can use any 3D editing tool to split the model's moveable flight control surfaces, I personally like MeshLab, since it's easy to use, and above all, it's completely free.

For further information about how to implement your own 3D model, have a look at the "import_stl_model" folder.


More information
================

* For more information about `aircraft_3d_animation`, have a look at this post on [Medium](https://github.com/matlab2tikz/matlab2tikz). If you are a good MATLAB(R) programmer, you are always welcome to help improving `aircraft_3d_animation` function!
* If you experience bugs or would like to request a feature, please visit our [issue tracker](https://github.com/Ro3code/aircraft_3d_animation/issues). 

