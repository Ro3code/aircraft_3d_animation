clearvars;
close all;
% Add path to stlTools
% You can download the package for free from: 
% https://es.mathworks.com/matlabcentral/fileexchange/51200-stltools
% addpath('./stlTools');
% Set the name of the mat file containing all the info of the 3D model
MatFileName = 'su57_3d_model.mat';
% Define the list of parts which will be part of the rigid aircraft body
rigid_body_list   = {...
'Fuselage.stl'  'Antennas_and_Probes.stl' 'Bleed.stl' 'Canopy.stl' 'CanopyFrame.stl' 'Left_engine.stl'  'Right_engine.stl' 'Rudder_support.stl' 'Frontgear_Bay.stl'};
% Define the color of each part
rigid_body_colors = 0.7 * ones(length(rigid_body_list), 3);
rigid_body_colors(2, : ) = 0.4 * [1 1 1];
rigid_body_colors(3, : ) = 0.1 * [1 1 1];
rigid_body_colors(4, : ) = 0.2 * [1 1 1];
rigid_body_colors(5, : ) = 0.9 * [1 1 1];
rigid_body_colors(6, : )  = 0.6 * [1 1 1];
rigid_body_colors(7, : )  = 0.6 * [1 1 1];

% Define the transparency of each part
alphas            = ones(1, length(rigid_body_list)); 
alphas(4)         = 0.2;
% Define the model ofset to center the A/C Center of Gravity
offset_3d_model   = 1* [2000, 0, +2500];

% Construct the main body
for i = 1:length(rigid_body_list)
    Model3D.Aircraft(i).model = rigid_body_list{i};
    Model3D.Aircraft(i).color = rigid_body_colors(i, :);
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
'model'                  'label'    'color'         'rot_offset_deg'  'rot_point'                                        'rot_vect'                      'max_deflection'};
Controls = {
'Left_LE.stl',        'LE_L',      0.5*[1, 1, 1],  0,                1e3*[3.9764   -6.7462    2.5126]-offset_3d_model,   [0.7116   -0.7025   0],         [0, 50];
'Right_LE.stl',       'LE_R',      0.5*[1, 1, 1],  0,                1e3*[3.9764   +6.7462    2.5126]-offset_3d_model,   [-0.7116   -0.7025   0],        [0, 50];
'Left_LEVCON.stl',    'LEVCON_L',  0.5*[1, 1, 1],  0,                1e3*[-2.5492   -1.0476    2.8212]-offset_3d_model,  [0.4359   -0.8859   -0.1586],   [0, 50];
'Right_LEVCON.stl',   'LEVCON_R',  0.5*[1, 1, 1],  0,                1e3*[-2.5492   +1.0476    2.8212]-offset_3d_model,  [-0.4359   -0.8859   +0.1586],  [0, 50];
'Left_Elevon.stl',    'ELEV_L',    0.5*[1, 1, 1],  0,                1.0e3*[7.7541   -2.1340    2.6043]-offset_3d_model, [0 1 0],                        [-30, +30];
'Right_Elevon.stl',   'ELEV_R',    0.5*[1, 1, 1],  0,                1.0e3*[7.7541   +2.1340    2.6043]-offset_3d_model, [0 1 0],                        [-30, +30];
'LIB_Flap.stl'        'LIB',       0.5*[1, 1, 1],  0,                1e3*[5.6218    -3.2835    2.6464]-offset_3d_model,  [+0.1809    0.9829   -0.0336],  [-30, +30];
'LOB_Flap.stl'        'LOB',       0.5*[1, 1, 1],  0,                1e3*[5.2039    -5.5638    2.5686]-offset_3d_model,  [-0.1534    0.9862   -0.0615],  [-30, +30];
'RIB_Flap.stl'        'RIB',       0.5*[1, 1, 1],  0,                1e3*[5.6218    3.2835    2.6464]-offset_3d_model,   [-0.1809    0.9829   -0.0336],  [-30, +30];
'ROB_Flap.stl'        'ROB',       0.5*[1, 1, 1],  0,                1e3*[5.2039    5.5638    2.5686]-offset_3d_model,   [ 0.1534    0.9862   -0.0615],  [-30, +30];
'Left_Rudder.stl',    'DR_L',      0.5*[1, 1, 1],  0,                [6500,       -2939.5,  2982.48]-offset_3d_model,    [0, -0.48, +1],                 [-30, +30];
'Right_Rudder.stl',   'DR_R',      0.5*[1, 1, 1],  0,                [6500,       +2939.5,  2982.48]-offset_3d_model,    [0, +0.48, +1],                 [-30, +30];
'WeaponBay_Left.stl'  'WB_L',      0.7*[1, 1, 1],  0,                1e3*[2.3989    -0.7071    1.9223]-offset_3d_model,  [+1, 0, 0],                     [0, 100];
'WeaponBay_Right.stl' 'WB_R',      0.7*[1, 1, 1],  0,                1e3*[2.3989    0.7071    1.9223]-offset_3d_model,   [-1, 0, 0],                     [0, 100];
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

% % Plot a cool GIF
% 
% filename = 'Su-57-Felon_360_view.gif';
% dt = 1/24;
% for i = 1: 4 * 24
%         
%         view([-90+30 + 360 * i / (4 * 24),  -20])
%         
%         drawnow;
%         
%         h = gcf;
%         
%         % Capture the plot as an image
%         frame = getframe(h);
%         im = frame2im(frame);
%         % Write to the GIF File
%         if i == 1
%             [imind, cm] = rgb2ind(im,256);
%             imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', dt);
%         else
%             imind = rgb2ind(im, cm);
%             imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', dt);
%         end
%         
% end

