
function dp = design_project(dp, make_plots, print_warnings)
%clear all
%close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Design constants
Vdd = 2.5;
Vss = -2.5;
VGnd = 0;
Rl = 20e3;
Cl = 250e-15;
Cin = 220e-15;

% Inputs
vov = dp.vov;

R1 = dp.r_eq_1 / (dp.ee214a.Vtn0 + vov);
R2 = R1 * dp.r_eq_1 / (R1 - dp.r_eq_1);

R4 = dp.r_eq_2 / (dp.ee214a.Vtn0 + vov);
R3 = R4 * dp.r_eq_2 / (R4 - dp.r_eq_2);

% Calculate v_bias_gen values
V_bias_gen_pmos = Vdd - vov + dp.ee214a.Vtp0;
V_bias_gen_nmos = Vss + vov + dp.ee214a.Vtn0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute k values

dp.MN1 = calc_k(dp.MN1);
dp.MN2 = calc_k(dp.MN2);
dp.MP3 = calc_k(dp.MP3);
dp.MP4 = calc_k(dp.MP4);
dp.MP5 = calc_k(dp.MP5);
dp.MN6 = calc_k(dp.MN6);
dp.MN7 = calc_k(dp.MN7);
dp.MP8 = calc_k(dp.MP8);
dp.MN9 = calc_k(dp.MN9);
dp.MN10 = calc_k(dp.MN10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute what we can for bias transistors

dp.MN1.vov = V_bias_gen_nmos - dp.MN1.vt - Vss;
dp.MP3.vov = Vdd - V_bias_gen_pmos + dp.MP3.vt;
dp.MN6.vov = V_bias_gen_nmos - dp.MN6.vt - Vss;
dp.MN9.vov = V_bias_gen_nmos - dp.MN9.vt - Vss;

dp.MN1 = calc_idsat(dp.MN1);
dp.MP3 = calc_idsat(dp.MP3);
dp.MN2.id = dp.MN1.id;

dp.MN6 = calc_idsat(dp.MN6);
dp.MN9 = calc_idsat(dp.MN9);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve for DC op points

% Stage 1
Vi = -sqrt(dp.MN1.k) * dp.MN1.vov / sqrt(dp.MN2.k) - dp.MN2.vt;
dp.Vx = (dp.MP3.id - dp.MN1.id + Vdd / R1) * dp.r_eq_1;
   
% Stage 2
dp.MP4.vov = dp.Vx - Vdd - dp.MP4.vt;
dp.MP4 = calc_idsat(dp.MP4);
dp.MP5.id = dp.MP4.id;

Vw = -sqrt(dp.MP4.k) * dp.MP4.vov / sqrt(dp.MP5.k) - dp.MP5.vt;
dp.Vy = (dp.MP4.id - dp.MN6.id + Vss / R4) * dp.r_eq_2;

% Stage 3
dp.MN7.vov = dp.Vy - Vss - dp.MN7.vt;
dp.MN7 = calc_idsat(dp.MN7);
dp.MP8.id = dp.MN7.id;

dp.Vz = (sqrt(dp.MP8.k) * (Vdd + dp.MP8.vt) - sqrt(dp.MN7.k) * dp.MN7.vov) / sqrt(dp.MP8.k);

% Stage 4
dp.Vo = -Rl * (dp.MN10.k * (dp.MN10.vt - dp.Vz) + dp.MN9.k * dp.MN9.vov^2) / ...
           (dp.MN10.k * Rl + 2);

dp.MN10 = calc_vov(dp.Vz, dp.Vo, dp.MN10);
dp.MN10 = calc_idsat(dp.MN10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check requirements for saturation

dp.MN1 = check_sat(Vi, V_bias_gen_nmos, Vss, dp.MN1);
dp.MN2 = check_sat(dp.Vx, 0, Vi, dp.MN1);
dp.MP3 = check_sat(dp.Vx, V_bias_gen_pmos, Vdd, dp.MP3);

dp.MP4 = check_sat(Vw, dp.Vx, Vdd, dp.MP4);
dp.MP5 = check_sat(dp.Vy, 0, Vw, dp.MP5);
dp.MN6 = check_sat(dp.Vy, V_bias_gen_nmos, Vss, dp.MN6);

dp.MN7 = check_sat(dp.Vz, dp.Vy, Vss, dp.MN7);
dp.MP8 = check_sat(dp.Vz, dp.Vz, Vdd, dp.MP8);

dp.MN9 = check_sat(dp.Vo, V_bias_gen_nmos, Vss, dp.MN9);
dp.MN10 = check_sat(Vdd, dp.Vz, dp.Vo, dp.MN10);

dp.all_sat = dp.MN1.sat_ok & dp.MN2.sat_ok & dp.MP3.sat_ok & dp.MP4.sat_ok & dp.MP5.sat_ok & ...
             dp.MN6.sat_ok & dp.MN7.sat_ok & dp.MP8.sat_ok & dp.MN9.sat_ok & dp.MN10.sat_ok;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute gms, caps and ros

dp.MN2 = calc_gm(dp.MN2);
dp.MP4 = calc_gm(dp.MP4);
dp.MN7 = calc_gm(dp.MN7);
dp.MP8 = calc_gm(dp.MP8);
dp.MN10 = calc_gm(dp.MN10);

dp.MN2 = calc_caps_sat(dp.MN2);
dp.MP3 = calc_caps_sat(dp.MP3);
dp.MP4 = calc_caps_sat(dp.MP4);
dp.MP5 = calc_caps_sat(dp.MP5);
dp.MN6 = calc_caps_sat(dp.MN6);
dp.MN7 = calc_caps_sat(dp.MN7);
dp.MP8 = calc_caps_sat(dp.MP8);
dp.MN9 = calc_caps_sat(dp.MN9);
dp.MN10 = calc_caps_sat(dp.MN10);

dp.MN1 = calc_ro(dp.MN1);
dp.MN2 = calc_ro(dp.MN2);
dp.MP3 = calc_ro(dp.MP3);
dp.MP4 = calc_ro(dp.MP4);
dp.MN6 = calc_ro(dp.MN6);
dp.MN7 = calc_ro(dp.MN7);
dp.MP8 = calc_ro(dp.MP8);
dp.MN9 = calc_ro(dp.MN9);
dp.MN10 = calc_ro(dp.MN10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stage 0 Iin -> Vin

stage_0.gain = 1;
stage_0.gain_db = 20 * log10(abs(stage_0.gain));
stage_0.c = Cin + dp.MN2.cgs;
stage_0.r = parallel_r(dp.MN1.ro, 1/dp.MN2.gm);
stage_0 = calculate_stage_speed(stage_0);
stage_0.pow = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stage 1 Vin -> dp.Vx

stage_1.gain = parallel_r(R1, R2);
stage_1.gain_db = 20 * log10(abs(stage_1.gain));
stage_1.c = dp.MP4.cgs + dp.MN2.cgd + dp.MP3.cgd;
stage_1.r = parallel_r(R1, R2, dp.MP3.ro, dp.MN2.gm * dp.MN2.ro * dp.MN1.ro);
stage_1 = calculate_stage_speed(stage_1);
stage_1.pow = dp.MN1.id * (Vdd-Vss) + Vdd^2 / (R1+R2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stage 2 dp.Vx -> dp.Vy

stage_2.gain = -dp.MP4.gm * parallel_r(R3, R4);
stage_2.gain_db = 20 * log10(abs(stage_2.gain));
stage_2.c = dp.MN7.cgs + dp.MP5.cgd + dp.MN6.cgd;
stage_2.r = parallel_r(R3, R4, dp.MN6.ro);
stage_2 = calculate_stage_speed(stage_2);
stage_2.pow = dp.MN6.id * (Vdd-Vss) + Vss^2 / (R3+R4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stage 3 dp.Vy -> dp.Vz

stage_3.gain = -dp.MN7.gm / dp.MP8.gm;
stage_3.gain_db = 20 * log10(abs(stage_3.gain));
stage_3.c = dp.MP8.cgs + dp.MN10.cgs;
stage_3.r = 1 / dp.MP8.gm;
stage_3 = calculate_stage_speed(stage_3);
stage_3.pow = dp.MN7.id * (Vdd-Vss);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stage 4 dp.Vz -> dp.Vo

stage_4.gain = dp.MN10.gm * Rl;
stage_4.gain_db = 20 * log10(abs(stage_4.gain));
stage_4.c = dp.MN9.cgd + Cl;
stage_4.r = Rl;
stage_4 = calculate_stage_speed(stage_4);
stage_4.pow = dp.MN9.id * (Vdd-Vss) + dp.Vo^2 / (Rl);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Total Gain

stages = {stage_0, stage_1, stage_2, stage_3, stage_4};

total.gain = 1;
for i = 1:length(stages)
  total.gain = total.gain * stages{i}.gain;
end
total.gain_db = 20 * log10(abs(total.gain));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Power

total.pow = 0;
for i = 1:length(stages)
  total.pow = total.pow + stages{i}.pow;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Requirements

trans = {dp.MN1, dp.MN2, dp.MP3, dp.MP4, dp.MP5, dp.MN6, dp.MN7, dp.MP8, dp.MN9, dp.MN10};

if print_warnings

  % Check Saturation
  for i = length(trans)
    if not(trans{i}.sat_ok)
      warning('Transistor %s not in saturation!', trans{i}.name);
    end
  end

  % Check Total Gain
  min_gain = 90;
  if total.gain_db < min_gain
    warning('Total gain too low, %0.1f < %0.1f', total.gain_db, min_gain);
  end

  % Check Stage Speed
  max_tc = 1.59e-9;
  for i = 1:length(stages)
    if stages{i}.t > max_tc
      warning('Stage %d Time Constant too high, %0.1fns > %0.1fns', ...
              i-1, stages{i}.t * 1e9, max_tc * 1e9);
    end
  end

  % Check Total Power
  max_pow = 2e-3;
  if total.pow > max_pow
    warning('Total power too high, %0.1f > %0.1f', total.pow, max_pow);
  end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make Interesting Plots
if make_plots
  
  plot_stages(stages);

end