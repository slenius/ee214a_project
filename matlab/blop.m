
clear all;
close all



vov = 0.7
speed_goal_i = 300e6;
speed_goal_x = 300e6;
speed_goal_y = 300e6;

s1 = compute_stage_i_size(speed_goal_i, vov)
s1 = 3;
s2 = 6;
s3 = 2;
s4 = 28;
n_z = 1;
vy_goal = -1.55;
vx_goal = 1.3;

dp = load_defaults(vov, s1, s2, s3, s4, 10000, 28571, n_z, vx_goal, vy_goal, s4);
%rx = compute_stage_x_res(speed_goal_x, dp.MN2.w, dp.MN2.l, dp.MP4.w, dp.MP4.l)
%ry = compute_stage_y_res(speed_goal_y, dp.MN6.w, dp.MN6.l, dp.MN7.w, dp.MN7.l)
%dp = load_defaults(vov, s1, s2, s3, s4, rx, ry, n_z, vx_goal, vy_goal, s4);
dp = design_project(dp, false, true);

make_spice_file(dp, 'matlab.sp', true);
fi = dp.stages{1}.f/1e6
fx = dp.stages{2}.f/1e6
fy = dp.stages{3}.f/1e6
fz = dp.stages{4}.f/1e6
fo = dp.stages{5}.f/1e6
ft = dp.total.f/1e6
g = dp.total.gain_db
p = dp.total.pow * 1e3
gbw = g * ft/1e6
vy_goal

% Bias generator
dp.MP100.w = 4e-6;
dp.MP100.l = 2e-6;

dp.MP200.w = 4e-6;
dp.MP200.l = 2e-6;

dp.MN300.w = 2e-6;
dp.MN300.l = 2e-6;

dp.MN400.w = 4e-6;
dp.MN400.l = 2e-6;

dp.MN700.w = 5e-6;
dp.MN700.l = 2e-6;

dp.MP800.w = 4e-6;
dp.MP800.l = 9e-6;

dp.MN900.w = 4e-6;
dp.MN900.l = 2e-6;


dp = print_areas(dp);

check_15y(dp);