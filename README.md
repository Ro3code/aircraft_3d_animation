![alt text](https://github.com/Ro3code/aircraft_3d_animation/blob/main/departure_animation.gif?raw=true)
# Aircraft 3D Animation Function
![GitHub](https://img.shields.io/github/license/Ro3code/aircraft_3d_animation) [![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger) ![GitHub top language](https://img.shields.io/github/languages/top/Ro3code/aircraft_3d_animation) [![View Aircraft 3D Animation on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://es.mathworks.com/matlabcentral/fileexchange/86453-aircraft-3d-animation)

A lightweight MATLAB® function to easily visualize flight test data recordings and outputs of nonlinear flight dynamics simulators. To download the official releases and rate `aircraft_3d_animation` function, please visit its page on [FileExchange](https://es.mathworks.com/matlabcentral/fileexchange/86453-aircraft-3d-animation).

Features
============
* 3D aircraft models with moveable flight control surfaces: the SAAB Gripen and the North American X-15 
* Flight control surfaces saturation monitors (color highlighting of saturated surfaces) 
* Departure from controlled flight monitor (red color highlighting) 
* Selectable maneuver reproduction speed 
* Export maneuver animation to an MP4 video file
* Highly customizable for other aircraft 3D model

Installation
============

1. Extract the ZIP file (or clone the git repository) somewhere you can easily reach it. 
2. Add the `src/` folder to your path in MATLAB: e.g. 
    - using the "Set Path" dialog in MATLAB, or 
    - by running the `addpath` function from your command window or `startup` script.
    
Usage
=====

Just feed your flight test or simulation data to the `aircraft_3d_animation` function as follows:

```matlab
%% Example script to visualize the aircraft simulation data
% Add the path of the aircraft_3d_animation function
addpath('../src/');
% path of the *.mat file containing the 3d model information
model_info_file = '../3d_models/saab_gripen_3d_model.mat';
% Load the simulation data
% load('scissors_maneuver.mat')
% load('breakaway_maneuver.mat')
% load('split_s_maneuver.mat')
load('departure.mat')
% define the reproduction speed factor
speedx = 1; 
% Do you want to save the animation in a mp4 file? (0.No, 1.Yes)
isave_movie = 0;
% Movie file name
movie_file_name = '';

% -------------------------------------------------------------------------
% The frame sample time shall be higher than 0.02 seconds to be able to 
% update the figure (CPU/GPU constraints)
frame_sample_time = max(0.02, tout(2)-tout(1));
% Resample the time vector to modify the reproduction speed
t_new   = tout(1):frame_sample_time*(speedx):tout(end);
% Resample the recorded data
act     = interp1(tout, act, t_new','linear');
stick   = interp1(tout, stick, t_new','linear');
y_new   = interp1(tout, yout, t_new','linear');
% We have to be careful with angles with ranges
y_new(:, 7)  = atan2(interp1(tout, sin(yout(:, 7)), t_new','linear'), interp1(tout, cos(yout(:, 7)), t_new','linear')) * 180 / pi;
y_new(:, 8)  = atan2(interp1(tout, sin(yout(:, 8)), t_new','linear'), interp1(tout, cos(yout(:, 8)), t_new','linear')) * 180 / pi;
y_new(:, 9)  = atan2(interp1(tout, sin(yout(:, 9)), t_new','linear'), interp1(tout, cos(yout(:, 9)), t_new','linear')) * 180 / pi;
% Assign the data
heading_deg           =  y_new(:, 7);
pitch_deg             =  y_new(:, 8);
bank_deg              =  y_new(:, 9);
roll_command          = -stick(:, 2);
pitch_command         = -stick(:, 1);
angle_of_attack_deg   =  y_new(:, 2) * 180 / pi;
angle_of_sideslip_deg =  y_new(:, 3) * 180 / pi;
fligh_path_angle_deg  =  y_new(:, 22) * 180 / pi;
mach                  =  y_new(:, 21);
altitude_ft           = -y_new(:, 12);
nz_g                  =  y_new(:, 19);
% Flight control surfaces
le     = act(:, 9);
dr     = act(:, 8);
df1    = act(:, 6);
df2    = act(:, 5);
df3    = act(:, 4);
df4    = act(:, 3);
dfp    = 0.5 * (act(:, 1) + act(:, 2));
% Control array assignation
% (modify the order according to your particular 3D model)
controls_deflection_deg = [dfp(:), dfp(:), le(:), le(:), dr(:), 0.5*(df1(:)+df2(:)), 0.5*(df3(:)+df4(:))];

%% Run aircraft_3d_animation function
% -------------------------------------------------------------------------
aircraft_3d_animation(model_info_file,...
    heading_deg, ...            Heading angle [deg]
    pitch_deg, ...              Pitch angle [deg]
    bank_deg, ...               Roll angle [deg]
    roll_command, ...           Roll  stick command [-1,+1] [-1 -> left,            +1 -> right]
    pitch_command, ...          Pitch stick command [-1,+1] [-1 -> full-back stick, +1 -> full-fwd stick]
    angle_of_attack_deg, ...    AoA [deg]
    angle_of_sideslip_deg, ...  AoS [deg]
    fligh_path_angle_deg, ...   Flight path angle [deg]
    mach, ...                   Mach number
    altitude_ft, ...            Altitude [ft]
    nz_g,  ...                  Vertical load factor [g]
    controls_deflection_deg, ...Flight control deflection (each column is a control surface)
    frame_sample_time, ...      Sample time [sec]
    speedx, ...                 Reproduction speed
    isave_movie, ...            Save the movie? 0-1
    movie_file_name);           % Movie file name
```

How to Use Other Aircraft 3D Models
===================================

The first thing you will need to do is to look for is a 3D model in *.stl format (STereoLithography) that best represents the external geometry of the plane or air vehicle.

There is a wide variety of web pages where you can find an infinity of 3D models to download for free. I recommend you to have a look at the following websites where you will surely find the 3D model you are looking for:

* [GrabCad](https://grabcad.com/)
* [Clara.io](https://clara.io/library)
* [Sketchfab](https://sketchfab.com/feed)

As `aircraft_3d_animation` function allows animating the moving parts of the aircraft, first, you will have to separate the 3D model into two sets of parts/submodels: the rigid parts that are solidly attached to the main body (fuselage, wings, cockpit, etc.), and set of parts that can move and/or rotate with respect to the main body (flight control surfaces, landing gear, etc.). You can use any 3D editing tool to split the model's moveable flight control surfaces, I personally like [MeshLab](https://www.meshlab.net/), since it's easy to use, and above all, it's completely free.

For further information about how to implement your own 3D model, have a look at the [import_stl_model](https://github.com/Ro3code/aircraft_3d_animation/tree/main/import_stl_model) folder.

More information
================

* For more information about `aircraft_3d_animation`, have a look at this post on [Medium](https://medium.com/codestory/3d-animations-made-simple-with-matlab-visualizing-flight-test-data-and-simulation-results-ed399cdcc711). If you are a good MATLAB® programmer, you are always welcome to help improving `aircraft_3d_animation` function!
* If you experience bugs or would like to request a feature, please visit our [issue tracker](https://github.com/Ro3code/aircraft_3d_animation/issues). 
