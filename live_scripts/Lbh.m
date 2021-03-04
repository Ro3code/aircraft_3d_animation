function Lbh = Lbh(heading_deg, pitch_deg, phi)
% Rotation matrix from NED axis to Aircraft's body axis
sps = sind(heading_deg);
cps = cosd(heading_deg);
sth = sind(pitch_deg);
cth = cosd(pitch_deg);
sph = sind(phi);
cph = cosd(phi);
Lb1 = [...
    1   0   0
    0   cph sph
    0  -sph cph];
L12 = [...
    cth 0   -sth
    0   1   0
    sth 0   cth];
L2h = [...
    cps sps 0
    -sps cps 0
    0   0   1];
Lbh = Lb1 * L12 * L2h;
end