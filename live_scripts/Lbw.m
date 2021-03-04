function Lbw = Lbw(angle_of_attack, angle_of_sideslip)
% Rotation matrix from Wind-axis to Aircraft's body axis
sa = sind(angle_of_attack);
ca = cosd(angle_of_attack);
sb = sind(angle_of_sideslip);
cb = cosd(angle_of_sideslip);
Lbw = [...
    ca*cb -ca*sb -sa
    sb cb 0
    sa*cb -sa*sb ca];
end