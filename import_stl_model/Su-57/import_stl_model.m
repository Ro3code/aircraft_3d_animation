clearvars;
close all;
% Add path to stlTools
% You can download the package for free from: 
% https://es.mathworks.com/matlabcentral/fileexchange/51200-stltools
addpath('./stlTools');
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

% Save mat file
save(MatFileName, 'Model3D');

%% Check the results
% Get maximum dimension to plot the circles afterwards
AC_DIMENSION = max(max(sqrt(sum(Model3D.Aircraft(1).stl_data.vertices.^2,2))));
for i=2:length(Model3D.Aircraft)
    AC_DIMENSION = max(AC_DIMENSION,max(max(sqrt(sum(Model3D.Aircraft(i).stl_data.vertices.^2,2)))));
end
for i=1:length(Model3D.Control)
    AC_DIMENSION = max(AC_DIMENSION,max(max(sqrt(sum(Model3D.Control(i).stl_data.vertices.^2,2)))));
end

iSaveMovie = 0;
AX = axes('position',[0.0 0.0 1 1]);
axis off
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[scrsz(3)/40 scrsz(4)/12 scrsz(3)/2*1.0 scrsz(3)/2.2*1.0]*(1-0.0*iSaveMovie),'Visible','on');
set(AX,'color','none');
axis('equal')
hold on;
cameratoolbar('Show')
% Initializate rotations handles
% -------------------------------------------------------------------------
% Aircraft
AV_hg(1)      = hgtransform;
% Controls
CONT_hg       = zeros(1,length(Model3D.Control));
for i=1:length(Model3D.Control)
    CONT_hg(i) = hgtransform('Parent',AV_hg(1),'tag',Model3D.Control(i).label);
end
% Circles around the aircraft
euler_hgt(1)  = hgtransform('Parent',AX,'tag','OriginAxes');
euler_hgt(2)  = hgtransform('Parent',euler_hgt(1),'tag','roll_disc');
euler_hgt(3)  = hgtransform('Parent',euler_hgt(1),'tag','pitch_disc');
euler_hgt(4)  = hgtransform('Parent',euler_hgt(1),'tag','heading_disc');
euler_hgt(5)  = hgtransform('Parent',euler_hgt(2),'tag','roll_line');
euler_hgt(6)  = hgtransform('Parent',euler_hgt(3),'tag','pitch_line');
euler_hgt(7)  = hgtransform('Parent',euler_hgt(4),'tag','heading_line');

% Plot objects
% -------------------------------------------------------------------------
% Plot airframe
for i = 1:length(Model3D.Aircraft)
    AV(i) = patch(Model3D.Aircraft(i).stl_data,  'FaceColor',        Model3D.Aircraft(i).color, ...
        'EdgeColor',        'none',        ...
        'FaceLighting',     'gouraud',     ...
        'AmbientStrength',   0.15,         ...
        'LineSmoothing',    'on',...
        'Parent',            AV_hg(1), ...
        'FaceAlpha',         Model3D.Aircraft(i).alpha, ...
        'LineSmoothing', 'on');
end
material(AV, 'metal');
material(AV(3), 'shiny');

CONT(length(Model3D.Control))=0;
% Plot controls
for i=1:length(Model3D.Control)
    CONT(i) = patch(Model3D.Control(i).stl_data,  'FaceColor',        Model3D.Control(i).color, ...
        'EdgeColor',        'none',        ...
        'FaceLighting',     'gouraud',     ...
        'AmbientStrength',  0.15,          ...
        'LineSmoothing',    'on',...
        'Parent',           CONT_hg(i));
    % Plot the rotation point and the rotation axis of each control
    % (double-check correct implementation and rotation direction of each
    % control surface)
    p = Model3D.Control(i).rot_point;
    vect = Model3D.Control(i).rot_vect;
    plot3(p(1)+[0, AC_DIMENSION*vect(1)/2], p(2)+[0, AC_DIMENSION*vect(2)/2], p(3)+[0, AC_DIMENSION*vect(3)/2], 'b-o', 'MarkerSize', 10);
end
% Fixing the axes scaling and setting a nice view angle
axis('equal');
axis([-1 1 -1 1 -1 1] * 2.0 * AC_DIMENSION)
set(gcf,'Color',[1 1 1])
axis off
view([40 30])
% Add a camera light, and tone down the specular highlighting
camlight('left');
% material('shiny');
camzoom(3.0);

% --------------------------------------------------------------------
% Define the radius of the sphere
R = 1.0 * AC_DIMENSION;

% Outer circles
phi = (-pi:pi/36:pi)';
D1 = [sin(phi) cos(phi) zeros(size(phi))];
HP(1) = plot3(R*D1(:,1),R*D1(:,2),+R*D1(:,3),'Color','b','tag','Zplane','Parent',euler_hgt(4));
HP(2) = plot3(R*D1(:,2),R*D1(:,3),+R*D1(:,1),'Color',[0 0.8 0],'tag','Yplane','Parent',euler_hgt(3));
HP(3) = plot3(R*D1(:,3),R*D1(:,1),+R*D1(:,2),'Color','r','tag','Xplane','Parent',euler_hgt(2));

% +0,+90,+180,+270 Marks
S = 0.95;
phi = -pi+pi/2:pi/2:pi;
D1 = [sin(phi); cos(phi); zeros(size(phi))];
plot3([S*R*D1(1,:); R*D1(1,:)],[S*R*D1(2,:); R*D1(2,:)],[S*R*D1(3,:); R*D1(3,:)],'Color','b','tag','Zplane','Parent',euler_hgt(4));
plot3([S*R*D1(2,:); R*D1(2,:)],[S*R*D1(3,:); R*D1(3,:)],[S*R*D1(1,:); R*D1(1,:)],'Color',[0 0.8 0],'tag','Yplane','Parent',euler_hgt(3));
plot3([S*R*D1(3,:); R*D1(3,:)],[S*R*D1(1,:); R*D1(1,:)],[S*R*D1(2,:); R*D1(2,:)],'Color','r','tag','Xplane','Parent',euler_hgt(2));
text(R*1.05*D1(1,:),R*1.05*D1(2,:),R*1.05*D1(3,:),{'N','E','S','W'},'Fontsize',9,'color',[0 0 0],'HorizontalAlign','center','VerticalAlign','middle');

% +45,+135,+180,+225,+315 Marks
S = 0.95;
phi = -pi+pi/4:2*pi/4:pi;
D1 = [sin(phi); cos(phi); zeros(size(phi))];
plot3([S*R*D1(1,:); R*D1(1,:)],[S*R*D1(2,:); R*D1(2,:)],[S*R*D1(3,:); R*D1(3,:)],'Color','b','tag','Zplane','Parent',euler_hgt(4));
HT = text(R*1.05*D1(1,:),R*1.05*D1(2,:),R*1.05*D1(3,:),{'NW','NE','SE','SW'},'Fontsize',8,'color',[0 0 0],'HorizontalAlign','center','VerticalAlign','middle');

% 10 deg sub-division marks
S = 0.98;
phi = -[0:10:90 80:-10:0 -10:-10:-90 -80:10:0];
PHI_TEXT{length(phi)}='';
for i=1:length(phi)
    PHI_TEXT{i} = num2str(phi(i));
end
theta_t = -[0:10:90 80:-10:0 -10:-10:-90 -80:10:0];
THETA_TEXT{length(theta_t)}='';
for i=1:length(theta_t)
    THETA_TEXT{i} = num2str(theta_t(i));
end
phi = -180:10:180;
phi = phi*pi/180;
D1 = [sin(phi); cos(phi); zeros(size(phi))];
plot3([S*R*D1(1,:); R*D1(1,:)],[S*R*D1(2,:); R*D1(2,:)],[S*R*D1(3,:); R*D1(3,:)],'Color','b','tag','Zplane','Parent',euler_hgt(4));
plot3([S*R*D1(2,:); R*D1(2,:)],[S*R*D1(3,:); R*D1(3,:)],[S*R*D1(1,:); R*D1(1,:)],'Color',[0 0.8 0],'tag','Yplane','Parent',euler_hgt(3));
plot3([S*R*D1(3,:); R*D1(3,:)],[S*R*D1(1,:); R*D1(1,:)],[S*R*D1(2,:); R*D1(2,:)],'Color','r','tag','Xplane','Parent',euler_hgt(2));

% Plot guide lines
HL(1) = plot3([-R R],[0 0],[0 0],'b-','tag','heading_line','parent',euler_hgt(7));
HL(2) = plot3([-R R],[0 0],[0 0],'g-','tag','pitch_line','parent',euler_hgt(6),'color',[0 0.8 0]);
HL(3) = plot3([0 0],[-R R],[0 0],'r-','tag','roll_line','parent',euler_hgt(5));


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

