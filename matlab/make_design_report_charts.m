clear all
close all


vov = 1.05;
speed_goal_i = 300e6;
speed_goal_x = 300e6;
speed_goal_y = 300e6;

vystep = 0:-0.025:-2.5;

for i = 1:length(vystep)

  s1 = 3;
  s2 = 8;
  s3 = 2;
  s4 = 28;
  n_z = 1;
  vy_goal = vystep(i);
  vx_goal = 1.3;

  dp = load_defaults(vov, s1, s2, s3, s4, 20000, 50000, n_z, vx_goal, vy_goal, s4);
  rx = compute_stage_x_res(speed_goal_x, dp.MN2.w, dp.MN2.l, dp.MP4.w, dp.MP4.l);
  ry = compute_stage_y_res(speed_goal_y, dp.MN6.w, dp.MN6.l, dp.MN7.w, dp.MN7.l);
  dp = load_defaults(vov, s1, s2, s3, s4, rx, ry, n_z, vx_goal, vy_goal, s4);
  dp = design_project(dp, false, false);

  if dp.all_sat
    y(i) = dp.Vy;
    z(i) = dp.Vz;
    o(i) = dp.Vo;
  else
    y(i) = nan;
    z(i) = nan;
    o(i) = nan;
  end
end

figure('Position', [100, 100, 400, 300]);
hold on;
plot(z, o, 'b-');
plot([min(z) max(z)], [0.15 0.15], 'r-');
plot([min(z) max(z)], [-0.15 -0.15], 'r-');
plot([1.0 1.0], [min(o) 0], 'm-');
xlabel('V(Z)');
ylabel('V(Output)');
title('Output Common Mode Voltage vs V(Z)');
legend('Common Mode Voltage', 'Spec+', 'Spec-', 'Goal V(Z)');

figure('Position', [100, 100, 400, 300]);
hold on;
plot(y, z, 'b-');
plot([min(y) -1.3], [1 1], 'm-');
plot([-1.3 -1.3], [min(z) 1], 'k-');
xlabel('V(Y)');
ylabel('V(Z)');
title('V(Z) vs V(Y)');
legend('V(Z) vs V(Y)', 'Goal V(Z)', 'Goal V(Y)');


s1step = 2:20;

for i = 1:length(s1step)

  s1 = s1step(i);
  s2 = 8;
  s3 = 2;
  s4 = 28;
  n_z = 1;
  vy_goal = -1.2;
  vx_goal = 1.3;

  dp = load_defaults(vov, s1, s2, s3, s4, 10000, 10000, n_z, vx_goal, vy_goal, s4);
  %rx = compute_stage_x_res(speed_goal_x, dp.MN2.w, dp.MN2.l, dp.MP4.w, dp.MP4.l);
  %ry = compute_stage_y_res(speed_goal_y, dp.MN6.w, dp.MN6.l, dp.MN7.w, dp.MN7.l);
  %dp = load_defaults(vov, s1, s2, s3, s4, rx, ry, n_z, vx_goal, vy_goal, s4);
  dp = design_project(dp, false, true);

  if dp.all_sat
    mn2(i) = dp.MN2.w*1e6;
    ti(i) = dp.stages{1}.t*1e9;
    tx(i) = dp.stages{2}.t*1e9;
    tsum(i) = ti(i) + tx(i);
  else
    mn2(i) = nan;
    ti(i) = nan;
    tx(i) = nan;
    tsum(i) = nan;
  end
end

figure('Position', [100, 100, 400, 300]);
hold on;
plot(mn2, ti, 'b-');
plot(mn2, tx, 'r-');
plot(mn2, tsum, 'm-');
xlabel('MN2 Width (um)');
ylabel('Tau(ns)');
title('Taus vs MN2 Width for X Stage Gain = 10000');
legend('Tau In', 'Tau X', 'Sum Tau');


%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Waveform Plot
f = fopen('../waveform_export.txt');
fgetl(f)
c = textscan(f, '%f %f %f');
fclose(f);
t = c{1};
v_iin = c{2};
v_vout = c{3};

figure;
hold on;
plot(t*1e9, v_vout);
legend('Vout');
title('Transient Response');
xlabel('Time (ns)')
ylabel('Voltage');
