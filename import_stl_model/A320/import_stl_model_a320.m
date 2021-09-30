clearvars;
close all;
% Add path to stlTools
% You can download the package for free from: 
% https://es.mathworks.com/matlabcentral/fileexchange/51200-stltools
addpath('./stlTools');
% Set the name of the mat file containing all the info of the 3D model
MatFileName = '../../3d_models/a320_3d_model.mat';
% Define the list of parts which will be part of the rigid aircraft body
% First part should always be main aircraft body
rigid_body_list   = { 'Body_A320.stl','Engine_L_A320.stl','Engine_R_A320.stl'};
% Define the color of each part
rigid_body_colors = {0.8 * [1, 1, 1], 0.1 * [1, 1, 1], 0.1 * [1, 1, 1]};
% Define the transparency of each part
alphas            = [              1,               1,               1];
% Define the model ofset to center the A/C Center of Gravity
offset   = [0,0,0];
% Define the control surfaces
ControlsFieldNames = {...
'model'                 'label',             'color',                'rot_point',           'rot_vect', 'max_deflection'};
Controls = {                                                                                                       
'Aileron_L_A320.stl',     'A_L',   0.3*[0.8, 0.8, 1], [515.1,-1434,80.5]-offset, [ 0.2932,-0.9523, 0.0843], [-30, +30];
'Aileron_R_A320.stl',     'A_R',   0.3*[0.8, 0.8, 1], [515.1,+1434,80.5]-offset, [ 0.2932, 0.9523, 0.0843], [-30, +30];
'Rudder_A320.stl',        'RUD',   0.3*[0.8, 0.8, 1], [ 1954,     0,550.1]-offset,-[ 0.3064, 0, 0.9519], [-30, +30];
'Elevator_L_A320.stl', 'STAB_L',   0.3*[0.8, 0.8, 1], [ 2037,-352.9,168.5]-offset, [-0.2952, 0.9481,-0.1179], [-30, +30];
'Elevator_R_A320.stl', 'STAB_R',   0.3*[0.8, 0.8, 1], [ 2037,+352.9,168.5]-offset, [ 0.2952, 0.9481, 0.1179], [-30, +30];
};
% Definition of the Model3D data structure
% Rigid body parts
for i = 1:length(rigid_body_list)
    Model3D.Aircraft(i).model = rigid_body_list{i};
    Model3D.Aircraft(i).color = rigid_body_colors{i};
    Model3D.Aircraft(i).alpha = alphas(i);
    % Read the *.stl file
   [Model3D.Aircraft(i).stl_data.vertices, Model3D.Aircraft(i).stl_data.faces, ~, Model3D.Aircraft(i).label] = stlRead(rigid_body_list{i});
    Model3D.Aircraft(i).stl_data.vertices  = Model3D.Aircraft(i).stl_data.vertices - offset;
end
% Controls parts
for i = 1:size(Controls, 1)
    for j = 1:size(Controls, 2)
        Model3D.Control(i).(ControlsFieldNames{j}) = Controls{i, j};
    end
    % Read the *.stl file
    [Model3D.Control(i).stl_data.vertices, Model3D.Control(i).stl_data.faces, ~, ~] = stlRead( Model3D.Control(i).model);
    Model3D.Control(i).stl_data.vertices = Model3D.Control(i).stl_data.vertices - offset;
end

%% Save mat file
save(MatFileName, 'Model3D');

%% Check the results
plot3Dmodel(MatFileName)