clear all
close all

dp = load_defaults();

% First test the linkage of sizing MN1, MN2 and MN3
size_sweep = 2e-6 : 1e-6 : 20e-6;
for i = 1:length(size_sweep)
  stage_1_size_link = size_sweep(i);
  dp.MN1.w = stage_1_size_link;
  dp.MN2.w = stage_1_size_link;
  dp.MP3.w = stage_1_size_link * 2;
  test = design_project(dp, false, false);
  Vx(i) = test.Vx;
  gm2(i) = test.MN2.gm;
end

figure;
X = size_sweep * 1e6;
[ax,p1,p2] = plotyy(X, Vx, X, 1./gm2);
set(p1, 'Marker', '*');
set(p2, 'Marker', '*');
title('Testing Stage 1 Size Linkage');
legend('Vx', 'MN2 1/gm');
xlabel('Size(um)')
ylabel(ax(1), 'Voltage(V)')
ylabel(ax(2), 'Resistance(ohms)')


