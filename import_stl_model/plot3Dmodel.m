function plot3Dmodel(MatFileName)
%PLOT3DMODEL(MatFileName)
% Plots the given 3d model, test for animation function
%

load(MatFileName)

%% Check the results
% Get maximum dimension to plot the circles afterwards
AC_DIMENSION = max(max(sqrt(sum(Model3D.Aircraft(1).stl_data.vertices.^2,2))));
for i=1:length(Model3D.Control)
    AC_DIMENSION = max(AC_DIMENSION,max(max(sqrt(sum(Model3D.Control(i).stl_data.vertices.^2,2)))));
end
% Define the figure properties
AX = axes('position',[0.0 0.0 1 1]);
axis off
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[scrsz(3)/40 scrsz(4)/12 scrsz(3)/2*1.0 scrsz(3)/2.2*1.0],'Visible','on');
set(AX,'color','none');
axis('equal')
hold on;
cameratoolbar('Show')
% Circles around the aircraft transformation group handles
euler_hgt(1)  = hgtransform('Parent',           AX, 'tag', 'OriginAxes');
euler_hgt(2)  = hgtransform('Parent', euler_hgt(1), 'tag', 'roll_disc');
euler_hgt(3)  = hgtransform('Parent', euler_hgt(1), 'tag', 'pitch_disc');
euler_hgt(4)  = hgtransform('Parent', euler_hgt(1), 'tag', 'heading_disc');
euler_hgt(5)  = hgtransform('Parent', euler_hgt(2), 'tag', 'roll_line');
euler_hgt(6)  = hgtransform('Parent', euler_hgt(3), 'tag', 'pitch_line');
euler_hgt(7)  = hgtransform('Parent', euler_hgt(4), 'tag', 'heading_line');
% Plot objects
% -------------------------------------------------------------------------
% Plot airframe
for i = 1:length(Model3D.Aircraft)
    AV = patch(Model3D.Aircraft(i).stl_data,  'FaceColor',        Model3D.Aircraft(i).color, ...
        'EdgeColor',        'none',        ...
        'FaceLighting',     'gouraud',     ...
        'AmbientStrength',   0.15);
end
CONT(length(Model3D.Control))=0;
% Plot controls
for i=1:length(Model3D.Control)
    CONT(i) = patch(Model3D.Control(i).stl_data,  'FaceColor',        Model3D.Control(i).color, ...
        'EdgeColor',        'none',        ...
        'FaceLighting',     'gouraud',     ...
        'AmbientStrength',  0.15);
    % Plot the rotation point and the rotation axis of each control
    % (double-check correct implementation and rotation direction of each
    % control surface)
    p = Model3D.Control(i).rot_point;
    vect = Model3D.Control(i).rot_vect;
    plot3(p(1)+[0, AC_DIMENSION*vect(1)/2], p(2)+[0, AC_DIMENSION*vect(2)/2], p(3)+[0, AC_DIMENSION*vect(3)/2], 'b-o', 'MarkerSize', 10, 'LineWidth', 2);
end
% Fixing the axes scaling and setting a nice view angle
axis('equal');
axis([-1 1 -1 1 -1 1] * 2.0 * AC_DIMENSION)
set(gcf,'Color',[1 1 1])
axis off
view([30 10])
zoom(2.0);
% Add a camera light, and tone down the specular highlighting
camlight('left');
material('dull');

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
end