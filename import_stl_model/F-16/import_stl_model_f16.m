clearvars;
close all;
% Add path to stlTools
% You can download the package for free from: 
% https://es.mathworks.com/matlabcentral/fileexchange/51200-stltools
addpath('./stlTools');
% Set the name of the mat file containing all the info of the 3D model
MatFileName = '../../3d_models/f16_3d_model.mat';
% Define the list of parts which will be part of the rigid aircraft body
% First part should always be main aircraft body
rigid_body_list   = { 'Body_F16.stl','Cockpit_F16.stl'};
% Define the color of each part
rigid_body_colors = {0.8 * [1, 1, 1], 0.1 * [1, 1, 1]};
% Define the transparency of each part
alphas            = [              1,               0.9];
% Define the model ofset to center the A/C Center of Gravity
offset   = [0,0,0];
% Define the control surfaces
ControlsFieldNames = {...
'model'                  'label',             'color',                'rot_point',           'rot_vect', 'max_deflection'};
Controls = {                                                                                                       
'Aileron_A_F16.stl',       'A_L',   0.3*[0.8, 0.8, 1], [358.7,-302.1,-7.3]-offset,-[-0.0768, 0.9970, 0], [-30, +30];
'Aileron_B_F16.stl',       'A_R',   0.3*[0.8, 0.8, 1], [358.7,+302.1,-7.3]-offset, [ 0.0768, 0.9970, 0], [-30, +30];
'LE_Slat_A_F16.stl',      'LE_L',   0.3*[0.8, 0.8, 1], [167.7,-316.8,-5.7]-offset, [-0.5081, 0.8613, 0], [ -1, +30];
'LE_Slat_B_F16.stl',      'LE_R',   0.3*[0.8, 0.8, 1], [167.7,+316.8,-5.7]-offset, [ 0.5081, 0.8613, 0], [ -1, +30];
'Rudder_F16.stl',          'RUD',   0.3*[0.8, 0.8, 1], [692.2,    0,203.2]-offset,-[ 0.5127, 0, 0.8586], [-30, +30];
'Stabilator_A_F16.stl', 'STAB_L',   0.3*[0.8, 0.8, 1], [640.5,-129.2,-7.6]-offset, [      0,      1, 0], [-30, +30];
'Stabilator_B_F16.stl', 'STAB_R',   0.3*[0.8, 0.8, 1], [640.5,+129.2,-7.6]-offset, [      0,      1, 0], [-30, +30];
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