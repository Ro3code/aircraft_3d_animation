clearvars;
close all;
% Add path to stlTools
% You can download the package for free from: 
% https://es.mathworks.com/matlabcentral/fileexchange/51200-stltools
addpath('./stlTools');
% Set the name of the mat file containing all the info of the 3D model
MatFileName = 'x15_3d_model.mat';
% Define the list of parts which will be part of the rigid aircraft body
rigid_body_list   = {...
'Canopy.stl'          'Q_ball.stl'          'Windows.stl'         'X-15_Airframe_Mod.stl'  'Back.stl'};
% Define the color of each part
rigid_body_colors = {0.0 * [1, 1, 1], 0.5 * [1, 1, 1], 0.0 * [1, 1, 1],    0.2 * [1, 1, 1],    0.7 * [1, 1, 1]};
% Define the transparency of each part
alphas            = [              1,               1,               1,                1,      1];
% Define the model ofset to center the A/C Center of Gravity
offset_3d_model   = 1 * [0.2, 0, -0.015];

% Construct the main body
for i = 1:length(rigid_body_list)
    Model3D.Aircraft(i).model = rigid_body_list{i};
    Model3D.Aircraft(i).color = rigid_body_colors{i};
    Model3D.Aircraft(i).alpha = alphas(i);
    % Read the *.stl file
   [Model3D.Aircraft(i).stl_data.vertices, Model3D.Aircraft(i).stl_data.faces, ~, Model3D.Aircraft(i).label] = stlRead(rigid_body_list{i});
    y = Model3D.Aircraft(i).stl_data.vertices(:, 2);
    z = Model3D.Aircraft(i).stl_data.vertices(:, 3);
    Model3D.Aircraft(i).stl_data.vertices(:, 2) = -z;
    Model3D.Aircraft(i).stl_data.vertices(:, 3) =  y;
    Model3D.Aircraft(i).stl_data.vertices  = Model3D.Aircraft(i).stl_data.vertices - offset_3d_model;
end

% Define the controls 
ControlsFieldNames = {...
'model'                  'label'    'color'         'rot_offset_deg'  'rot_point'                                   'rot_vect'                                               'max_deflection'};
Controls = {
'Left_Aileron.stl',      'AIL_L',    0.5*[1, 1, 1],  0,                [0.3193, -0.1467, -0.01564]-offset_3d_model,  [0,  1, 0],                                            [-30, +30];
'Right_Aileron.stl',     'AIL_R',    0.5*[1, 1, 1],  0,                [0.3193, +0.1467, -0.01564]-offset_3d_model,  [0,  1, 0],                                            [-30, +30];
'Left_Elevator.stl',    'ELEV_L',    0.5*[1, 1, 1],  0,                [0.7135, -0.1404, -0.01433]-offset_3d_model,  [0.7135, -0.1404, -0.004]-[0.7135, -0.3502, -0.08956], [-30, +30];
'Right_Elevator.stl',   'ELEV_R',    0.5*[1, 1, 1],  0,                [0.7135, +0.1404, -0.01433]-offset_3d_model,  [0.7135, -0.1404, +0.004]-[0.7135, -0.3502, +0.08956], [-30, +30];
'Left_AB.stl',            'AB_L',    0.5*[1, 1, 1],  0,                [0.7155, -0.0266,  0.1387]-offset_3d_model,   [0, 0, -1],                                            [-30, +30];
'Right_AB.stl',           'AB_R',    0.5*[1, 1, 1],  0,                [0.7155, +0.0266,  0.1387]-offset_3d_model,   [0, 0, +1],                                            [-30, +30];
'Rudder.stl',               'DR',    0.5*[1, 1, 1],  0,                [0.7135,       0,  0]-offset_3d_model,        [0, 0, +1],                                            [-30, +30];
};

for i = 1:size(Controls, 1)
    for j = 1:size(Controls, 2)
        Model3D.Control(i).(ControlsFieldNames{j}) = Controls{i, j};
    end
    % Read the *.stl file
    [Model3D.Control(i).stl_data.vertices, Model3D.Control(i).stl_data.faces, ~, ~] = stlRead( Model3D.Control(i).model);
    y = Model3D.Control(i).stl_data.vertices(:, 2);
    z = Model3D.Control(i).stl_data.vertices(:, 3);
    Model3D.Control(i).stl_data.vertices(:, 2) = -z;
    Model3D.Control(i).stl_data.vertices(:, 3) =  y;
    Model3D.Control(i).stl_data.vertices = Model3D.Control(i).stl_data.vertices - offset_3d_model;
    
end

%% Save mat file
save(MatFileName, 'Model3D');

%% Check the results
plot3Dmodel(MatFileName)