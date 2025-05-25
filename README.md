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

Prerequisites
=============
- MATLAB R2018b or newer.
- Robotics System Toolbox: Required only if you want to import new 3D models using the provided `import_stl_model` scripts. The core `aircraft_3d_animation` function and examples run with pre-processed `.mat` model files and do not require this toolbox.

Installation
============

There are two main ways to get the code:

1.  **Download a ZIP file:**
    *   Go to the [main GitHub page](https://github.com/Ro3code/aircraft_3d_animation).
    *   Click on the green "Code" button, then "Download ZIP".
    *   Extract the ZIP file to a folder on your computer where you can easily find it (e.g., `C:\MATLAB_Addons\aircraft_3d_animation` or `~/Documents/MATLAB/aircraft_3d_animation`).

2.  **Clone the Git Repository (Recommended for updates):**
    *   Open a terminal or command prompt.
    *   Navigate to the directory where you want to store the project.
    *   Run the command:
        ```bash
        git clone https://github.com/Ro3code/aircraft_3d_animation.git
        ```
    *   This will create a folder named `aircraft_3d_animation` with all the code.

Once you have the code, you need to tell MATLAB where to find the `aircraft_3d_animation` function. This is done by adding the `src/` folder (which is inside the main `aircraft_3d_animation` folder) to the MATLAB path. MATLAB needs this path to locate and execute the function when you call it in your scripts.

There are a couple of ways to add the `src/` folder to the MATLAB path:

*   **Using the "Set Path" Dialog (Temporary for current session or permanent):**
    1.  In the MATLAB Home tab, go to the "Environment" section.
    2.  Click on "Set Path".
        *   *(A GIF here showing the "Set Path" dialog button would be helpful.)*
    3.  In the Set Path dialog window, click "Add Folder".
    4.  Navigate to the `aircraft_3d_animation` directory you downloaded or cloned, and then select the `src` folder inside it.
    5.  Click "Select Folder".
    6.  Click "Save" in the Set Path dialog. This will save the path for future MATLAB sessions. If you don't click "Save", the path will only be active for the current session.
        *   *(A screenshot here illustrating the "Add Folder" and "Save" steps would be beneficial.)*

*   **Using the `addpath` command (Temporary for current session or permanent via `startup.m`):**
    *   To add the path for the current MATLAB session, type the following in the MATLAB Command Window, replacing `'/path/to/your/aircraft_3d_animation/src'` with the actual path to the `src` folder:
        ```matlab
        addpath('/path/to/your/aircraft_3d_animation/src');
        ```
        For example, if you cloned the repository to `C:\Projects\aircraft_3d_animation`, the command would be:
        ```matlab
        addpath('C:\Projects\aircraft_3d_animation\src');
        ```
    *   **To make this permanent (Recommended):** You can add this `addpath` command to your `startup.m` file. MATLAB executes this file every time it starts.
        1.  To find your `startup.m` file, type `userpath` in the MATLAB command window. This usually shows the path to your default MATLAB documents folder (e.g., `C:\Users\YourUsername\Documents\MATLAB` or `~/Documents/MATLAB`).
        2.  If you don't have a `startup.m` file in that directory, you can create one (it's just a plain text file with MATLAB commands).
        3.  Add the `addpath('/path/to/your/aircraft_3d_animation/src');` line (with the correct path) to this file and save it.
        *   *(A note here could mention checking MATLAB documentation for `startup.m` for more details.)*

After completing these steps, you should be able to run the example scripts or use the `aircraft_3d_animation` function in your own code.
    
Usage
=====

The `aircraft_3d_animation` function is the core of this repository. Below is a detailed explanation of its parameters, followed by a breakdown of the example script.

### `aircraft_3d_animation` Function Parameters:

The `aircraft_3d_animation` function accepts the following parameters. All time-series data (angles, commands, etc.) should be provided as Nx1 column vectors, where N is the number of time points.

*   `model_info_file` (string):
    *   Path to a `.mat` file containing the `Model3D` structure. This structure holds the geometric data for the aircraft model and its control surfaces.
    *   The `Model3D` structure must have two main fields:
        *   `Model3D.Aircraft`: A structure array where each element defines a rigid part of the aircraft (e.g., fuselage, wings). Each element must contain:
            *   `stl_data.vertices`: Vertex coordinates for the part.
            *   `stl_data.faces`: Face definitions for the part (how vertices connect).
            *   `model` (string): Original STL filename (for reference).
            *   `color` (1x3 array): RGB color for the part (e.g., `[0.5 0.5 0.5]` for grey).
            *   `alpha` (scalar): Transparency value (0 to 1, where 0 is fully transparent and 1 is fully opaque).
        *   `Model3D.Control`: A structure array where each element defines a moveable control surface. Each element must contain:
            *   `stl_data.vertices`: Vertex coordinates.
            *   `stl_data.faces`: Face definitions.
            *   `model` (string): Original STL filename.
            *   `label` (string): A unique name for the control surface (e.g., 'Rudder', 'Left_Aileron'). This is used for tagging objects in the animation.
            *   `color` (1x3 array): RGB color.
            *   `rot_offset_deg` (scalar): Rotation offset in degrees. This is an initial static rotation applied to the control surface before dynamic deflections. Typically set to 0.
            *   `rot_point` (1x3 array): Coordinates `[X, Y, Z]` of a point that lies on the control surface's axis of rotation.
            *   `rot_vect` (1x3 array): Vector `[X, Y, Z]` defining the direction of the axis of rotation for the surface.
            *   `max_deflection` (1x2 array): Minimum and maximum deflection angles `[min_deg, max_deg]` for the surface. These values are used to highlight control surfaces when they reach their specified limits (saturation).
    *   The `import_stl_model` folder in the repository contains scripts and examples on how to generate this `.mat` file from your own STL 3D models.

*   `heading_deg` (Nx1 array):
    *   Time series of the aircraft's heading angle (Yaw, ψ), defining its orientation relative to North.
    *   Units: Degrees.

*   `pitch_deg` (Nx1 array):
    *   Time series of the aircraft's pitch angle (Theta, θ), defining its orientation relative to the horizontal plane.
    *   Units: Degrees. Positive pitch is typically nose-up.

*   `bank_deg` (Nx1 array):
    *   Time series of the aircraft's bank angle (Roll, φ), defining its rotation around its longitudinal axis.
    *   Units: Degrees. Positive bank is typically right wing down.

*   `roll_command` (Nx1 array):
    *   Time series of the pilot's or autopilot's roll command input.
    *   Range: Normalized, typically expected between -1 and +1.
    *   Convention: -1 often corresponds to maximum left roll command (e.g., left stick/yoke), +1 to maximum right roll command. This is visualized in the stick position indicator.

*   `pitch_command` (Nx1 array):
    *   Time series of the pilot's or autopilot's pitch command input.
    *   Range: Normalized, typically expected between -1 and +1.
    *   Convention: -1 often corresponds to maximum nose-up command (e.g., full-back stick/yoke), +1 to maximum nose-down command (e.g., full-forward stick/yoke). This is visualized in the stick position indicator.

*   `angle_of_attack_deg` (Nx1 array):
    *   Time series of the aircraft's angle of attack (AoA, α), the angle between the relative wind and the aircraft's chord line.
    *   Units: Degrees.

*   `angle_of_sideslip_deg` (Nx1 array):
    *   Time series of the aircraft's angle of sideslip (AoS, β), the angle between the relative wind and the aircraft's plane of symmetry.
    *   Units: Degrees.

*   `fligh_path_angle_deg` (Nx1 array):
    *   Time series of the aircraft's flight path angle (Gamma, γ), the angle between the aircraft's velocity vector and the horizontal plane.
    *   Units: Degrees.

*   `mach` (Nx1 array):
    *   Time series of the aircraft's Mach number (speed relative to the speed of sound).

*   `altitude_ft` (Nx1 array):
    *   Time series of the aircraft's altitude.
    *   Units: Feet.

*   `nz_g` (Nx1 array):
    *   Time series of the vertical load factor experienced by the aircraft.
    *   Units: g (multiples of standard Earth gravity). Used for visual cues like departure warnings.

*   `controls_deflection_deg` (NxM array):
    *   Time series of the deflections for M control surfaces. Each column corresponds to a control surface defined in `Model3D.Control`.
    *   Units: Degrees.
    *   **Important:** The order of columns in this array *must* match the order of control surfaces defined in the `Model3D.Control` structure within the `model_info_file`. For example, if `Model3D.Control(1)` is the rudder and `Model3D.Control(2)` is the left aileron, then column 1 of `controls_deflection_deg` must be rudder deflections and column 2 must be left aileron deflections.

*   `frame_sample_time` (scalar):
    *   The desired time step for the animation frames in seconds. This is effectively the inverse of the animation's target frame rate (FPS).
    *   Example: `0.04` for 25 FPS, `0.02` for 50 FPS. The actual achieved frame rate can be lower due to computational load.

*   `speedx` (scalar):
    *   Reproduction speed factor for the animation.
    *   `1.0` means real-time playback.
    *   `2.0` means twice as fast as real-time.
    *   `0.5` means half of real-time speed.

*   `isave_movie` (scalar, 0 or 1):
    *   Flag to indicate whether to save the animation as an MP4 video file.
    *   `0`: Do not save the movie.
    *   `1`: Save the movie. If set to `1`, `movie_file_name` must be provided.

*   `movie_file_name` (string):
    *   The desired filename for the output MP4 video (e.g., `'my_animation.mp4'`).
    *   This parameter is only used if `isave_movie` is set to `1`.

The example script below shows how to prepare your data and call this function.

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

### Example Script Explanation

The example script provided demonstrates how to prepare your data and call the `aircraft_3d_animation` function. Let's break it down step-by-step:

1.  **`addpath('../src/');`**
    *   This line adds the `src` directory (which is assumed to be one level up and then into `src/` relative to the example script's location) to the MATLAB path. This is essential so that MATLAB can find the `aircraft_3d_animation.m` function file when you try to run the script.

2.  **`model_info_file = '../3d_models/saab_gripen_3d_model.mat';`**
    *   This line specifies the path to the `.mat` file that contains the 3D model's geometry and control surface definitions. In this case, it's using the pre-supplied SAAB Gripen model. You would change this path if you were using a different aircraft model `.mat` file.

3.  **`load('departure.mat')`**
    *   This command loads data from a MAT-file named `departure.mat`. This file is expected to contain the flight data from a simulation or a real flight test.
    *   Typically, such a file would include variables like:
        *   `tout`: A vector of time points.
        *   `yout`: A matrix where each column represents a different aircraft state variable (like pitch rate, velocity, Euler angles, etc.) over time.
        *   `act`: A matrix of actuator deflections (control surface positions) over time.
        *   `stick`: A matrix of pilot stick (or control input) positions over time.
    *   The specific variable names (`tout`, `yout`, `act`, `stick`) are common but might vary depending on your simulation software or data acquisition system. You'll need to adapt the script if your variable names are different.

4.  **`speedx = 1;`**
    *   This variable sets the playback speed of the animation. A value of `1` means the animation plays in real-time (relative to the time data in `tout`).
    *   `speedx = 2;` would play at double speed.
    *   `speedx = 0.5;` would play at half speed.

5.  **`isave_movie = 0;`** and **`movie_file_name = '';`**
    *   `isave_movie = 0;` instructs the function *not* to save the animation as an MP4 video file.
    *   If you want to save the animation, you would set `isave_movie = 1;` and provide a filename in `movie_file_name`, for example, `movie_file_name = 'departure_animation.mp4';`.

6.  **Data Resampling Block:**
    This section is crucial for preparing the raw simulation/flight data for smooth animation at a consistent frame rate, adjusted by the `speedx` factor.
    *   **`frame_sample_time = max(0.02, tout(2)-tout(1));`**
        *   This line calculates the time interval between frames for the animation.
        *   `tout(2)-tout(1)`: This part estimates the original sample time of the input data (assuming `tout` is uniformly sampled).
        *   `max(0.02, ...)`: This ensures that the animation's frame sample time is at least 0.02 seconds (which corresponds to a maximum of 50 frames per second). This is a practical lower limit to prevent excessive computational load for marginal visual gain and to ensure the animation can be rendered reasonably smoothly by MATLAB. If the original data has a very high sample rate, this line effectively downsamples it for the animation.
    *   **`t_new = tout(1):frame_sample_time*(speedx):tout(end);`**
        *   This creates a new time vector `t_new` that will be used for the animation frames.
        *   It starts at the first time point of the original data (`tout(1)`).
        *   It ends at the last time point of the original data (`tout(end)`).
        *   The step size is `frame_sample_time * speedx`. The `speedx` variable scales this step:
            *   If `speedx = 1`, `t_new` has points spaced by `frame_sample_time`.
            *   If `speedx > 1` (faster playback), the time step between animation frames is larger, meaning the animation skips more of the original data points, making the aircraft appear to move faster.
            *   If `speedx < 1` (slower playback), the time step is smaller, leading to more interpolated frames between original data points, making the aircraft appear to move slower.
    *   **`act = interp1(tout, act, t_new','linear');`** (and similar lines for `stick` and `y_new`)
        *   `interp1` is MATLAB's 1-dimensional interpolation function. It's used here to resample the original data (`act`, `stick`, `yout`) at the new time points defined by `t_new`.
        *   `tout`: The original time vector corresponding to the original data.
        *   `act`: The original data matrix for actuator positions.
        *   `t_new'`: The new query points (the animation time vector, transposed to be a column vector).
        *   `'linear'`: This specifies that linear interpolation should be used. Linear interpolation calculates new values by drawing straight lines between the original data points. It's a common choice that balances computational efficiency with reasonable accuracy for many types of flight data.
    *   **Angle Interpolation (e.g., `y_new(:, 7) = atan2(interp1(tout, sin(yout(:, 7)), t_new','linear'), interp1(tout, cos(yout(:, 7)), t_new','linear')) * 180 / pi;`)**
        *   This more complex interpolation is used for angular data like heading (`y_new(:, 7)`), pitch (`y_new(:, 8)`), and bank (`y_new(:, 9)`).
        *   Direct linear interpolation of angles can be problematic when an angle wraps around (e.g., from 359° to 1°). Interpolating directly might make the aircraft rotate the "long way around" (e.g., from 359° through 180° to 1° instead of just 2°).
        *   To avoid this:
            1.  The original angle (e.g., `yout(:, 7)`) is decomposed into its sine and cosine components (`sin(yout(:, 7))` and `cos(yout(:, 7))`).
            2.  These sine and cosine components are then interpolated linearly using `interp1` at the new time points `t_new`.
            3.  The `atan2` function is then used with the interpolated sine and cosine values. `atan2(sin_val, cos_val)` correctly reconstructs the angle, handling all quadrants and ensuring the shortest path for angular changes.
            4.  The result from `atan2` is in radians, so it's multiplied by `180 / pi` to convert it back to degrees, which is the unit expected by the animation function.

7.  **Data Assignment Block (e.g., `heading_deg = y_new(:, 7);`)**
    *   This section takes the columns from the resampled `y_new` matrix (and `stick`, `act` matrices) and assigns them to variables with descriptive names (e.g., `heading_deg`, `pitch_deg`). These are the variables that will be directly passed to the `aircraft_3d_animation` function.
    *   The column indices (e.g., `y_new(:, 7)`) depend on how your specific simulation data is structured in the `yout` matrix. You must ensure these indices correctly map to heading, pitch, bank, AoA, etc.
    *   Some lines include `* 180 / pi`. This implies that the original data for those specific angles in `yout` was in radians, and it's being converted to degrees here, as the animation function expects degree inputs for angles.

8.  **`controls_deflection_deg = [dfp(:), dfp(:), le(:), le(:), dr(:), 0.5*(df1(:)+df2(:)), 0.5*(df3(:)+df4(:))];`**
    *   This line constructs the `controls_deflection_deg` matrix. Each column of this matrix represents the deflection of a specific control surface over time.
    *   The comment `(modify the order according to your particular 3D model)` is extremely important. The number of columns and the meaning of each column *must* correspond precisely to the order and definition of control surfaces in the `Model3D.Control` array within the `model_info_file` you are using.
    *   For example, if the `saab_gripen_3d_model.mat` defines 7 control surfaces in a specific order (e.g., 1:Left Elevon, 2:Right Elevon, 3:Left Leading Edge, ...), then this `controls_deflection_deg` matrix must have 7 columns, and the data in each column must correspond to the correct surface. The example shows specific calculations (e.g., `0.5*(df1(:)+df2(:))`) which are tailored to how the SAAB Gripen's control surfaces are mapped from the `act` variable in the `departure.mat` file. This mapping will likely be different for other aircraft models or data sets.

9.  **`aircraft_3d_animation(...)` call**
    *   This is the final step, where the `aircraft_3d_animation` function is actually called. All the previously prepared and resampled data variables are passed as arguments to the function to generate and display the animation. The comments next to each argument in the example provide a quick reminder of what each variable represents.

This detailed breakdown should help you understand how to adapt the example script for your own flight data and 3D aircraft models.

How to Use Other Aircraft 3D Models
===================================

Using your own aircraft 3D models with `aircraft_3d_animation` involves preparing your models appropriately and then using helper scripts to convert them into the required `.mat` format.

**1. Finding or Creating 3D Models:**

*   Look for models in `.stl` (STereoLithography) format. This is a common format for 3D printing and CAD.
*   Websites to find free or paid 3D models:
    *   [GrabCad](https://grabcad.com/)
    *   [Clara.io](https://clara.io/library)
    *   [Sketchfab](https://sketchfab.com/feed)
    *   Thingiverse, CGTrader, TurboSquid, etc.
*   Alternatively, you can create your own models using 3D modeling software like Blender, SolidWorks, Fusion 360, etc., and export them as STL files.

**2. Preparing Your 3D Model Parts:**

This is a critical step that requires a 3D modeling tool. [MeshLab](https://www.meshlab.net/) (free, open-source) is recommended in the original documentation, and [Blender](https://www.blender.org/) (free, open-source) is another powerful option.

*   **Separate Parts:** You must divide your aircraft model into individual components:
    *   **Rigid Parts:** These are parts that form the main, non-moving structure of the aircraft (e.g., fuselage, main wings, vertical stabilizer, canopy). Each major rigid component can be a separate STL file.
    *   **Movable Parts (Control Surfaces):** These are the parts that will be animated (e.g., ailerons, elevators, rudder, flaps, slats, speed brakes). Each distinct movable surface *must* be a separate STL file.
    *   Save each part as an individual STL file (e.g., `fuselage.stl`, `left_aileron.stl`, `rudder.stl`).

*   **Mesh Simplification:**
    *   STL models, especially those from detailed CAD designs or high-quality artistic renderings, can have very high polygon counts (many triangles). While detailed models look good, they can significantly slow down MATLAB's rendering performance during the animation.
    *   **Advice:** Simplify the mesh (reduce polygon count) for each part. For visualization, highly detailed meshes are often unnecessary. Aim for a balance between visual fidelity and performance. A few thousand to tens of thousands of polygons per visible part is often a good target. Most 3D editing tools (MeshLab, Blender) offer mesh decimation or simplification features.

*   **Axis Alignment and Centering:**
    *   **Standard Aircraft Axes Convention:** The animation function implicitly expects a standard aerospace axis convention for the imported model data:
        *   **+X axis:** Points forward (out the nose of the aircraft).
        *   **+Y axis:** Points out the right wing.
        *   **+Z axis:** Points downwards (belly of the aircraft).
    *   When you prepare and export your STL parts, try to align them to this convention in your 3D modeling software *before* exporting each part. If your modeling software uses a different convention (e.g., Z-axis pointing upwards), you will need to ensure your `import_stl_model` script correctly rotates the vertex data upon import.
    *   **Centering (Defining the Origin):** The aircraft model in the animation will rotate around the origin `[0,0,0]` of the coordinate system defined by your imported STL files. You need to decide where this origin should be on your aircraft (e.g., the projected center of gravity, the nose, a specific reference point). The `import_stl_model` scripts (e.g., `import_stl_model/SAAB-Gripen/import_stl_model_gripen.m`) use an `offset_3d_model` variable. This vector is subtracted from the vertex coordinates of all parts. You'll need to determine this offset for your model, often by finding the geometric center of your main body STL or a known reference point from its design, to effectively shift your desired aircraft origin to `[0,0,0]`.

*   **Units and Scaling:**
    *   STL files themselves are unitless; the numerical values for vertices are just numbers. These numbers could represent millimeters, meters, inches, etc., depending on how the model was created and exported.
    *   The `import_stl_model` scripts load the STL vertex data as is. The `offset_3d_model` in these scripts should use the same units as your STL files.
    *   **Advice:**
        *   Be aware of the units your STL model was designed in.
        *   The main `aircraft_3d_animation` function expects the final processed model (in the `.mat` file) to be at a scale that is visually consistent with the flight path data (e.g., if altitude is in feet and position changes are in meters, your model needs to be scaled appropriately to look correct).
        *   If your STL model's inherent units (e.g., millimeters) are different from the units you want for the animation (e.g., meters), you must apply a scaling factor to the vertex data and the `offset_3d_model` within your custom `import_stl_model` script. For instance, if your STL is in mm and you want meters, multiply all vertex coordinates and the offset by 0.001. The example import scripts assume the STL units are consistent with the offset values defined and produce a model at a reasonable scale for typical flight data.

**3. Using the `import_stl_model` Scripts (Converting STLs to `.mat`):**

The `import_stl_model` folder in this repository contains example MATLAB scripts (e.g., `import_stl_model/SAAB-Gripen/import_stl_model_gripen.m`, `import_stl_model_f16.m`). These are **templates** that you *must adapt* to import your custom aircraft. **You will need the Robotics System Toolbox for the `stlread` function used in these scripts.**

*   **Purpose of the Scripts:** These scripts automate the process of:
    1.  Reading vertex and face data from your individual STL files.
    2.  Applying the necessary offset (and potentially scaling) to center and size your model.
    3.  Defining the visual properties (color, transparency) for each part.
    4.  Crucially, defining the kinematics for each movable control surface:
        *   `rot_point`: A point (1x3 vector) that lies on the axis of rotation of the control surface.
        *   `rot_vect`: A vector (1x3) defining the direction of the axis of rotation.
        *   `max_deflection`: A 1x2 vector `[min_angle, max_angle]` in degrees for saturation highlighting.
    5.  Packaging all this data into a single `Model3D` structure.
    6.  Saving this `Model3D` structure into a `.mat` file (e.g., `your_aircraft_model.mat`). This `.mat` file is what the main `aircraft_3d_animation` function uses.

*   **How to Use:**
    1.  **Copy an Existing Script:** Duplicate one of the example `import_stl_model` scripts (e.g., `import_stl_model_gripen.m`) and rename it for your aircraft.
    2.  **Modify Paths and File Lists:** Update the script to point to your STL files for rigid body parts and control surfaces.
    3.  **Set Visual Properties:** Define colors and alpha (transparency) for each part.
    4.  **Define `offset_3d_model`:** Calculate and set the correct offset to center your aircraft.
    5.  **(If needed) Add Scaling:** If your STL units require scaling, implement the multiplication of vertex data and offset here.
    6.  **Define Control Surface Kinematics:** For each control surface, carefully determine and input its `rot_point` and `rot_vect`. This is often the most challenging part and may require some trial and error. The `plot3Dmodel.m` script (also in the `import_stl_model` folder) is invaluable here. After running your import script, use `plot3Dmodel('your_aircraft_model.mat')` to visualize the static model and check if parts are correctly positioned and oriented. You can't test rotations here, but you can verify geometry.
    7.  **Run Your Script:** Execute your modified import script in MATLAB. This will generate the `.mat` file.
    8.  **Test with `aircraft_3d_animation`:** Use this new `.mat` file in one of the main example animation scripts (or your own script) to see if the control surfaces animate as expected. You may need to iterate on `rot_point` and `rot_vect` values.

**4. Potential Challenges During Import:**

*   **STL Format Variations:** While MATLAB's `stlread` function (from the Robotics System Toolbox) is generally robust, it primarily supports binary STL files. Some ASCII STL files or those with non-standard headers might cause issues. Ensure your STL files are clean and standard.
*   **Incorrect Scaling or Units:** If the model appears vastly too large or too small when you first plot it or animate it, you'll need to revisit the scaling factor in your import script.
*   **Model Not Centered Correctly:** If the aircraft is offset strangely in the animation, your `offset_3d_model` calculation is likely incorrect.
*   **Incorrect Surface Normals:** If parts of your model appear inside-out or are darkly shaded, the surface normals in your STL files might be inconsistent or pointing inwards. This usually needs to be fixed in your 3D modeling software by recalculating or flipping normals before re-exporting the STL.
*   **Defining Rotation Axes (`rot_point`, `rot_vect`):** This is the most common area for difficulty. Accurately defining the hinge line (axis of rotation) for each control surface requires careful measurement or knowledge of your 3D model's geometry.
    *   `rot_point`: Any point on the hinge line.
    *   `rot_vect`: A vector defining the direction of the hinge line. The sign of the vector combined with the sign of the deflection angle will determine the direction of rotation (e.g., clockwise/counter-clockwise). Use the right-hand rule for rotations.
    *   Iterative refinement using `plot3Dmodel` (for static checks) and then the main animation (to see dynamic movement) is often necessary.

By understanding these aspects and methodically working through the preparation and import script customization, you can successfully prepare your own aircraft 3D models for visualization with `aircraft_3d_animation`. The folder `import_stl_model` and its contents are your primary reference for this process.

## Troubleshooting

### Animation Not Starting / Errors during `aircraft_3d_animation` call

*   **Possible Cause:** Incorrect path to `model_info_file`.
    *   **Solution:** Double-check that the path provided for the `model_info_file` variable in your script is accurate, that the `.mat` file exists at that location, and that the file is not corrupted.
*   **Possible Cause:** Input data dimensions mismatch. For example, `heading_deg` has a different number of entries (rows) than `pitch_deg`.
    *   **Solution:** All time-series input data arrays (like heading, pitch, bank, AoA, AoS, altitude, Mach number, control surface deflections, etc.) must have the same length (number of rows). Verify the dimensions of your input matrices and vectors.
*   **Possible Cause:** The number of columns in `controls_deflection_deg` does not match the number of control surfaces defined in the `model_info_file`.
    *   **Solution:** Inspect the `Model3D.Control` structure within your aircraft's `.mat` model file to see how many control surfaces are defined and in what order. Ensure the `controls_deflection_deg` matrix has exactly that many columns, and that the order of deflections matches the order in `Model3D.Control`.
*   **Possible Cause:** `frame_sample_time` is invalid (e.g., too small, zero, or negative).
    *   **Solution:** The `frame_sample_time` should be a small positive number, typically 0.02 seconds or greater. Ensure this value is correctly set.
*   **Possible Cause:** Missing data (NaNs - Not a Number) in critical input arrays.
    *   **Solution:** Check your input data arrays for the presence of NaNs. NaNs in time-series data for attitude, position, or control inputs can cause errors. Implement a strategy to handle them, such as removing the time steps with NaNs or interpolating to fill the gaps.

### Model Not Displaying Correctly

*   **Possible Cause:** Aircraft model appears too small or too large in the animation.
    *   **Solution:** This is often due to the scale of the original STL model or the units used in your simulation data.
        *   Review the scaling options in the `import_stl_model` scripts (e.g., `scale_factor`). You may need to adjust this factor and re-import your model.
        *   Ensure consistency between the units of your simulation data (e.g., altitude in feet or meters) and the expectations of the animation function or model setup.
*   **Possible Cause:** Aircraft model is offset from the center of the animation window or behaves erratically.
    *   **Solution:**
        *   The `offset_3d_model` array in the `import_stl_model` scripts is used to center the model. You may need to adjust these X, Y, Z offsets and re-import the model.
        *   Ensure the model's STLs are defined with their origin at a sensible location (e.g., the aircraft's center of gravity or a consistent reference point).
*   **Possible Cause:** Control surfaces are moving in the wrong direction, around the wrong axis, or their movement range is incorrect.
    *   **Solution:** This requires careful adjustment of the control surface definition in the `import_stl_model` script for your specific aircraft. For each control surface, verify:
        *   `rot_point`: The point around which rotation occurs.
        *   `rot_vect`: The vector defining the axis of rotation.
        *   `max_deflection`: The maximum deflection angle.
        *   Re-import the model after making corrections. Use `plot3Dmodel.m` to test individual surface movements.
*   **Possible Cause:** Colors are incorrect, parts of the model are transparent when they shouldn't be, or parts are invisible.
    *   **Solution:**
        *   Visual properties like `FaceColor`, `EdgeColor`, and `FaceAlpha` (transparency) are defined in the `import_stl_model` scripts. Adjust these and re-import.
        *   Sometimes, original STL files can have "inverted normals" (the surfaces are pointing inward). This can affect lighting and visibility. This issue is best fixed in a 3D modeling tool before importing into MATLAB.

### Video Export Issues (`isave_movie = 1`)

*   **Possible Cause:** Errors during the creation or writing of the MP4 video file.
    *   **Solution:**
        *   **Write Permissions:** Ensure you have write permissions in the directory where you are trying to save the video. Try saving to a known user-writable directory (like 'Documents' or your MATLAB userpath).
        *   **File Name/Path:** Check that the `movie_file_name` is a valid file name and path. Avoid special characters if causing issues.
        *   **Disk Space:** Verify there is sufficient disk space available on the target drive.
        *   **MATLAB's `VideoWriter`:** For persistent or obscure errors, consult MATLAB's official documentation for the `VideoWriter` object. System-specific video codec availability can sometimes be a factor, though `VideoWriter` aims to be broadly compatible.
        *   **Interrupted Execution:** If the animation script is terminated prematurely (e.g., by an error or user interruption), the video file may not be finalized correctly and could be corrupted or unplayable.

### Performance Issues

*   **Possible Cause:** The animation runs very slowly, is choppy, or seems to lag significantly.
    *   **Solution:**
        *   **`frame_sample_time`:** Increase the `frame_sample_time` in your script. A larger value means fewer frames are rendered per second of simulated time, which can improve smoothness at the cost of temporal resolution.
        *   **3D Model Complexity:** Highly detailed 3D models (high polygon counts) can significantly impact rendering performance. If you imported your own model, try simplifying its mesh using a 3D modeling tool and then re-import it.
        *   **System Resources:** Close other CPU or GPU-intensive applications running on your computer.
        *   **Hardware:** Older computers with less powerful CPUs or integrated graphics may struggle with smooth 3D animation.

## Contributing

Contributions are welcome and appreciated! If you have suggestions for improvements, new features, or have found a bug, please feel free to:

1.  **Open an Issue:** Report bugs or suggest features by opening an issue on the [project's issue tracker](https://github.com/Ro3code/aircraft_3d_animation/issues). Please provide as much detail as possible, including steps to reproduce bugs.
2.  **Submit a Pull Request:** If you've made improvements to the code or documentation, please submit a pull request.
    *   Fork the repository.
    *   Create a new branch for your changes.
    *   Make your changes, ensuring code is well-commented and follows the existing style where possible.
    *   If adding a new feature or fixing a bug, consider adding an example or test case if applicable.
    *   Push your changes to your fork and submit a pull request to the main repository.

We value your contributions to make `aircraft_3d_animation` even better!

More information
================

* For more information about `aircraft_3d_animation`, have a look at this post on [Medium](https://medium.com/codestory/3d-animations-made-simple-with-matlab-visualizing-flight-test-data-and-simulation-results-ed399cdcc711). If you are a good MATLAB® programmer, you are always welcome to help improving `aircraft_3d_animation` function!
* If you experience bugs or would like to request a feature, please visit our [issue tracker](https://github.com/Ro3code/aircraft_3d_animation/issues).
