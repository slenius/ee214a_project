close all
clear all


% Make plots of how the devices behave in the triode region

dp.ee214a.unCox = 50e-6;
dp.ee214a.upCox = 25e-6;
dp.ee214a.Vtn0 = 0.5;
dp.ee214a.Vtp0 = -0.5;

dp.vdd = 2.5;
dp.vss = -2.5;


MN.w = 2e-6;
MN.l = 2e-6;
MN.type = 'nmos';
MN.name = 'test_trans';
MN.uCox = dp.ee214a.unCox;
MN.vt = dp.ee214a.Vtn0;

MN = calc_k(MN);
MN = calc_caps_sat(MN);

vd = 0:0.05:4;
vg = 0:0.05:5;

for i = 1:length(vd)
  for j = 1:length(vg)
    MN = calc_id(vd(i), vg(j), 0, MN);
    id(i, j) = MN.id;
    ro(i, j) = MN.ro_tri;
  end
end

figure;
plot(vd, id.*1e6);
xlabel('vds');
ylabel('id (uA)');

ro(ro > 12e3) = nan;
ro(ro < 8e3) = nan;


figure;
plot(vg, ro./1000)
xlabel('vgs');
ylabel('ro (kohms)');

[x, y] = meshgrid(vg, vd);
plot3(x, y, ro, '.')
xlabel('vg');
ylabel('vd');



