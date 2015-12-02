close all
clear all

vov = 0.15:0.025:1.0;

%Notes

% Input pole dependent on the width of stage 1 and vov
% Vx pole dependent on Rx and on Width 2
% Vo pole a string function of both stage 3 width and vov

% ideas
% set the bandwidth of the stages to a constant - and solve it for a given
% value of vov
% e.g. width of stage one is a parameter of vov
% e.g. width of stage two times Rx is a constant
% turn design into one thats parameterized by goals for the pole frequencies


speed_goal_i = 50e6;
speed_goal_x = 250e6;
speed_goal_y = 300e6;
speed_goal_z = 80e6;
speed_goal_o = 220e6;

for i = 1:length(vov)
  s1 = compute_stage_i_size(speed_goal_i, vov(i))
  %s1 = 3;
  %w1 = 8;
  s2 = 8;
  s3 = 2;
  s4 = 28;
  n_z = 1;
  %vov_y = compute_stage_z_vov(speed_goal_z, s3*1e-6, s3*1e-6, s4*1e-6, 2e-6, n_z);
  %vy_goal = vov_y - 2.0;
  vy_goal = -1.4;
  
  dp = load_defaults(vov(i), s1, s2, s3, s4, 20000, 50000, n_z, vy_goal, s4);
  rx = compute_stage_x_res(speed_goal_x, dp.MN2.w, dp.MN2.l, dp.MP4.w, dp.MP4.l);
  ry = compute_stage_y_res(speed_goal_y, dp.MN6.w, dp.MN6.l, dp.MN7.w, dp.MN7.l);
  dp = load_defaults(vov(i), s1, s2, s3, s4, rx, ry, n_z, vy_goal, s4);
  dp = design_project(dp, false, false);
  
  %mn9 = compute_mn9_size(s4, 2, 2, dp.Vz, dp.V_bias_gen_nmos);
  %dp = load_defaults(vov(i), s1, s2, s3, s4, rx, ry, n_z, vy_goal, mn9);
  %dp = design_project(dp, false, false);

  
  % dc levels
  if dp.all_sat
    Vi(i) = dp.Vi;
    Vx(i) = dp.Vx;
    Vy(i) = dp.Vy;
    Vz(i) = dp.Vz;
    Vo(i) = dp.Vo;
  else
    Vi(i) = nan;
    Vx(i) = nan;
    Vy(i) = nan;
    Vz(i) = nan;
    Vo(i) = nan;
  end
  if abs(vov(i) - 1) < 0.001
    make_spice_file(dp, 'matlab.sp');
    fi = dp.stages{1}.f
    fx = dp.stages{2}.f
    ft = dp.total.f
    g = dp.total.gain_db
    p = dp.total.pow * 1e3
    gbw = g * ft/1e6
    vy_goal
  end
  for stage = 1:5
    if dp.all_sat
      stage_speed(i, stage) = dp.stages{stage}.f;
      stage_gain_db(i, stage) = dp.stages{stage}.gain_db;
      stage_pow(i, stage) = dp.stages{stage}.pow;
    else
      stage_speed(i, stage) = nan;
      stage_gain_db(i, stage) = nan;
      stage_pow(i, stage) = nan;
    end
    stage_names{stage} = dp.stages{stage}.name;
  end
  stage_names{6} = 'Total';
  line_style{6} = '-';
  if dp.all_sat
    stage_gain_db(i, 6) = dp.total.gain_db;
    stage_speed(i, 6) = dp.total.f;
    stage_pow(i, 6) = dp.total.pow;
  else
    stage_gain_db(i, 6) = nan;
    stage_speed(i, 6) = nan;
    stage_pow(i, 6) = nan;
  end
  stage_names{7} = 'Spec';
  stage_gain_db(i, 7) = 90;
  stage_speed(i, 7) = 90e6;
  stage_pow(i, 7) = 2e-3;
end

figure;
p = plot(vov, stage_speed./1e6);
xlim([min(vov) max(vov)]);
xlabel('vov');
ylabel('Stage Speed (Mhz)');
title('Stage Speed vs Vov');
legend(stage_names);

figure;
p = plot(vov, stage_gain_db);
xlim([min(vov) max(vov)]);
xlabel('vov');
ylabel('Stage Gain (dB)');
title('Stage Gain vs Vov');
legend(stage_names);

figure;
p = plot(vov, stage_pow*1e6);
xlim([min(vov) max(vov)]);
xlabel('vov');
ylabel('Stage Power (uW)');
title('Stage Power vs Vov');
legend(stage_names);

figure;
p = plot(vov, Vo, 'b-');
hold on;
plot(vov, 0.15*ones(1, length(vov)), 'r-')
plot(vov, -0.15*ones(1, length(vov)), 'r-')
ylim([-2.5 2.5]);
xlim([min(vov) max(vov)]);
xlabel('vov');
ylabel('Output Voltage');
title('Output Voltage vs Vov');
legend('Output Voltage', 'Spec +', 'Spec -');

figure;
plot(vov, Vi, 'b-');
hold on;
plot(vov, Vx, 'g-');
plot(vov, Vy, 'r-');
plot(vov, Vz, 'c-');
plot(vov, Vo, 'm-');
ylim([-2.5 2.5]);
xlim([min(vov) max(vov)]);
xlabel('vov');
ylabel('DC Voltage');
title('Stage DC Voltage vs Vov');
legend('Vi', 'Vx', 'Vy', 'Vz', 'Vo');

% vov = [0.25, 0.75];
% w_2 = [2, 8];
% 
% [vov, w_2] = meshgrid(vov, w_2);
% vov = reshape(vov, numel(vov), 1);
% w_2 = reshape(w_2, numel(w_2), 1);
% r = linspace(1000, 30000, 30);
% 
% for i = 1:length(vov)
%   for j = 1:length(r)
%     dp = design_project(load_defaults(vov(i), 16, w_2(i), 2, 16, r(j), 20000, 1), false, false);
%     if dp.all_sat
%       gain_x(i,j) = dp.stages{2}.gain;
%       bw_x(i,j) = dp.stages{2}.f;
%     else
%       gain_x(i,j) = nan;
%       bw_x(i,j) = nan;
%     end
%   end
% end
% 
% gbw_x = gain_x .* bw_x;
% 
% for i = 1:length(vov)
%   leg{i} = sprintf('w = %d vov = %0.2f', w_2(i), vov(i));
% end

% figure;
% plot(r, gain_x)
% xlabel('Stage x Resistance')
% ylabel('Stage x Gain')
% legend(leg)
% 
% figure;
% plot(r, bw_x)
% xlabel('Stage x Resistance')
% ylabel('Stage x Bandwidth')
% legend(leg)
% 
% figure;
% plot(r, gbw_x)
% xlabel('Stage x Resistance')
% ylabel('Stage x Gain Bandwidth')
% legend(leg)
