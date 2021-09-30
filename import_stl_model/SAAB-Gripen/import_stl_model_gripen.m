clearvars;
close all;
% Add path to stlTools
% You can download the package for free from: 
% https://es.mathworks.com/matlabcentral/fileexchange/51200-stltools
% addpath('./stlTools');
% Set the name of the mat file containing all the info of the 3D model
MatFileName = 'saab_gripen_3d_model.mat';
% Define the list of parts which will be part of the rigid aircraft body
rigid_body_list   = {     'Body.stl',   'AB_Left.stl',  'AB_Right.stl', 'Canopy_Front.stl', 'Canopy_Rear.stl'};
% Define the color of each part
rigid_body_colors = {0.8 * [1, 1, 1], 0.6 * [1, 1, 1], 0.6 * [1, 1, 1],    0.1 * [1, 1, 1],   0.1 * [1, 1, 1]};
% Define the transparency of each part
alphas            = [              1,               1,               1,                0.9,               0.9];
% Define the model ofset to center the A/C Center of Gravity
offset_3d_model   = [8678.85, -15.48, 606.68];
% Define the controls 
ControlsFieldNames = {...
'model'              'label',             'color',                             'rot_point',            'rot_vect', 'max_deflection'};
Controls = {                                                                                                       
'FP_Right.stl',       'FP_R',   0.3*[0.8, 0.8, 1], [5719,   996.6,  600.0]-offset_3d_model,            [0,  1, 0], [-30, +30];
'FP_Left.stl',        'FP_L',   0.3*[0.8, 0.8, 1], [5719,  -996.6,  600.0]-offset_3d_model,            [0,  1, 0], [-30, +30];
'LE_Left.stl',        'LE_L',   0.3*[0.8, 0.8, 1], [9267, -2493.0,  380.2]-offset_3d_model,  [0.7849, -0.6197, 0], [ -1, +30];
'LE_right.stl',       'LE_R',   0.3*[0.8, 0.8, 1], [9267, +2493.0,  380.2]-offset_3d_model, [-0.7849, -0.7197, 0], [ -1, +30];
'Rudder.stl',          'RUD',   0.3*[0.8, 0.8, 1], [12930,    0.0, 1387.0]-offset_3d_model,            [0, 0, -1], [-30, +30];
'Elevon_Left.stl',  'FLAP_L',   0.3*[0.8, 0.8, 1], [11260, -860.9,  368.3]-offset_3d_model,  [+0.0034, 0.9999, 0], [-30, +30];
'Elevon_Right.stl', 'FLAP_R',   0.3*[0.8, 0.8, 1], [11260, +860.9,  368.3]-offset_3d_model,  [-0.0034, 0.9999, 0], [-30, +30];
};
% Definition of the Model3D data structure
% Rigid body parts
for i = 1:length(rigid_body_list)
    Model3D.Aircraft(i).model = rigid_body_list{i};
    Model3D.Aircraft(i).color = rigid_body_colors{i};
    Model3D.Aircraft(i).alpha = alphas(i);
    % Read the *.stl file
   [Model3D.Aircraft(i).stl_data.vertices, Model3D.Aircraft(i).stl_data.faces, ~, Model3D.Aircraft(i).label] = stlRead(rigid_body_list{i});
    Model3D.Aircraft(i).stl_data.vertices  = Model3D.Aircraft(i).stl_data.vertices - offset_3d_model;
end
% Controls parts
for i = 1:size(Controls, 1)
    for j = 1:size(Controls, 2)
        Model3D.Control(i).(ControlsFieldNames{j}) = Controls{i, j};
    end
    % Read the *.stl file
    [Model3D.Control(i).stl_data.vertices, Model3D.Control(i).stl_data.faces, ~, ~] = stlRead( Model3D.Control(i).model);
    Model3D.Control(i).stl_data.vertices = Model3D.Control(i).stl_data.vertices - offset_3d_model;
end

%% Save mat file
save(MatFileName, 'Model3D');

%% Check the results
plot3Dmodel(MatFileName)