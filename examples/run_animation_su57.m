%% Example script to visualize the aircraft simulation data
% Add the path of the aircraft_3d_animation function
addpath('../src/');
% path of the *.mat file containing the 3d model information
model_info_file = '../3d_models/su57_3d_model.mat';
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
le     = min(45, angle_of_attack_deg);
dr     = act(:, 8);
df1    = act(:, 6);
df2    = act(:, 5);
df3    = act(:, 4);
df4    = act(:, 3);
dfp    = 0.5 * (act(:, 1) + act(:, 2));
% Control array assignation
% (modify the order according to your particular 3D model)

% Controls = {
% 'Left_LE.stl',        'LE_L',      0.5*[1, 1, 1],  0,                1e3*[3.9764   -6.7462    2.5126]-offset_3d_model,  [0.7116   -0.7025   0];
% 'Right_LE.stl',       'LE_R',      0.5*[1, 1, 1],  0,                1e3*[3.9764   +6.7462    2.5126]-offset_3d_model,  [-0.7116   -0.7025   0];
% 'Left_LEVCON.stl',    'LEVCON_L',  0.5*[1, 1, 1],  0,                1e3*[-2.5492   -1.0476    2.8212]-offset_3d_model,   [0.4359   -0.8859   -0.1586];
% 'Right_LEVCON.stl',   'LEVCON_R',  0.5*[1, 1, 1],  0,                1e3*[-2.5492   +1.0476    2.8212]-offset_3d_model,   [-0.4359   -0.8859   +0.1586];
% 'Left_Elevon.stl',    'ELEV_L',    0.5*[1, 1, 1],  0,                1.0e3*[7.7541   -2.1340    2.6043]-offset_3d_model,  [0 1 0];
% 'Right_Elevon.stl',   'ELEV_R',    0.5*[1, 1, 1],  0,                1.0e3*[7.7541   +2.1340    2.6043]-offset_3d_model,  [0 1 0];
% 'LIB_Flap.stl'        'LIB',       0.5*[1, 1, 1],  0,                1e3*[5.6218    -3.2835    2.6464]-offset_3d_model,       [+0.1809    0.9829   -0.0336];
% 'LOB_Flap.stl'        'LOB',       0.5*[1, 1, 1],  0,                1e3*[5.2039    -5.5638    2.5686]-offset_3d_model,       [-0.1534    0.9862   -0.0615];
% 'RIB_Flap.stl'        'RIB',       0.5*[1, 1, 1],  0,                1e3*[5.6218    3.2835    2.6464]-offset_3d_model,        [-0.1809    0.9829   -0.0336];
% 'ROB_Flap.stl'        'ROB',       0.5*[1, 1, 1],  0,                1e3*[5.2039    5.5638    2.5686]-offset_3d_model,        [ 0.1534    0.9862   -0.0615];
% 'Left_Rudder.stl',    'DR_L',      0.5*[1, 1, 1],  0,                [6500,       -2939.5,  2982.48]-offset_3d_model,        [0, -0.48, +1];
% 'Right_Rudder.stl',   'DR_R',      0.5*[1, 1, 1],  0,                [6500,       +2939.5,  2982.48]-offset_3d_model,        [0, +0.48, +1];
% 'WeaponBay_Left.stl'  'WB_L',      0.5*[1, 1, 1],  0,                1e3*[2.3989    -0.7071    1.9223]-offset_3d_model,        [+1, 0, 0];
% 'WeaponBay_Right.stl' 'WB_R',      0.5*[1, 1, 1],  0,                1e3*[2.3989    0.7071    1.9223]-offset_3d_model,        [-1, 0, 0];
% };

controls_deflection_deg = [le(:), le(:),le(:), le(:), 0.25 * (df1(:)+df2(:)+df3(:)+df4(:)) - 0.25 * (-df1(:)-df2(:)+df3(:)+df4(:)), 0.25 * (df1(:)+df2(:)+df3(:)+df4(:)) + 0.25 * (-df1(:)-df2(:)+df3(:)+df4(:)), 0.25 * (df1(:)+df2(:)-df3(:)-df4(:)), 0.25 * (df1(:)+df2(:)-df3(:)-df4(:)), 0.25 * (-df1(:)-df2(:)+df3(:)+df4(:)), 0.25 * (-df1(:)-df2(:)+df3(:)+df4(:)), -dr(:), -dr(:), 0*dr(:), 0*dr(:)];

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