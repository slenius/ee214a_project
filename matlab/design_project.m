
function dp = design_project(dp, make_plots, print_warnings)
%clear all
%close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% number of iterations for  vt calc
iter = 10;

% Calculate v_bias_gen values
dp.V_bias_gen_pmos = dp.vdd - dp.vov + dp.ee214a.Vtp0;
dp.V_bias_gen_nmos = dp.vss + dp.vov + dp.ee214a.Vtn0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute vt values
dp.MN1 = calc_vt(dp.vss, dp.vss, dp.MN1);
dp.MN6 = calc_vt(dp.vss, dp.vss, dp.MN6);
dp.MN7 = calc_vt(dp.vss, dp.vss, dp.MN7);
dp.MN9 = calc_vt(dp.vss, dp.vss, dp.MN9);

dp.MP3 = calc_vt(dp.vdd, dp.vdd, dp.MP3);
dp.MP4 = calc_vt(dp.vdd, dp.vdd, dp.MP4);
dp.MP8 = calc_vt(dp.vdd, dp.vdd, dp.MP8);

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

dp.MN1.vov = dp.V_bias_gen_nmos - dp.MN1.vt - dp.vss;
dp.MP3.vov = dp.vdd - dp.V_bias_gen_pmos + dp.MP3.vt;
dp.MN6.vov = dp.V_bias_gen_nmos - dp.MN6.vt - dp.vss;
dp.MN9.vov = dp.V_bias_gen_nmos - dp.MN9.vt - dp.vss;

dp.MN1 = calc_idsat(dp.MN1);
dp.MP3 = calc_idsat(dp.MP3);
dp.MN2.id = dp.MN1.id;

dp.MN6 = calc_idsat(dp.MN6);
dp.MN9 = calc_idsat(dp.MN9);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve for DC op points

% Stage 1
dp.Vi = -1;
for i = 1:iter
  dp.MN2 = calc_vt(dp.Vi, dp.vss, dp.MN2);
  dp.Vi = -sqrt(dp.MN1.k) * dp.MN1.vov / sqrt(dp.MN2.k) - dp.MN2.vt;
end
dp.Vx = (dp.MP3.id - dp.MN1.id + dp.vdd / dp.R1.val) * parallel_r(dp.R1.val, dp.R2.val);

% Stage 2
dp.MP4.vov = dp.Vx - dp.vdd - dp.MP4.vt;
dp.MP4 = calc_idsat(dp.MP4);
dp.MP5.id = dp.MP4.id;

dp.Vw = 1;
for i = 1:iter
  dp.MP5 = calc_vt(dp.Vw, dp.vdd, dp.MP5);
  dp.Vw = -sqrt(dp.MP4.k) * dp.MP4.vov / sqrt(dp.MP5.k) - dp.MP5.vt;
end

dp.Vy = (dp.MP4.id - dp.MN6.id + dp.vss / dp.R4.val) * parallel_r(dp.R3.val, dp.R4.val);
%dp.Vy = resistor_div(dp.R3.val, dp.R4.val, 0, dp.vss);

% Stage 3
dp.MN7.vov = dp.Vy - dp.vss - dp.MN7.vt;
dp.MN7 = calc_idsat(dp.MN7);
dp.MP8.id = dp.MN7.id;

dp.Vz = (sqrt(dp.MP8.k) * (dp.vdd + dp.MP8.vt) - sqrt(dp.MN7.k) * ...
         dp.MN7.vov) / sqrt(dp.MP8.k);

% Stage 4
dp.Vo = 0;
for i = 1:iter
  dp.MN10 = calc_vt(dp.Vo, dp.vss, dp.MN10);
  dp.Vo = -dp.Rl * (dp.MN10.k * (dp.MN10.vt - dp.Vz) + ...
               dp.MN9.k * dp.MN9.vov^2) / ...
               (dp.MN10.k * dp.Rl + 2);
end

dp.MN10 = calc_vov(dp.Vz, dp.Vo, dp.MN10);
dp.MN10 = calc_idsat(dp.MN10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check requirements for saturation

dp.MN1 = check_sat(dp.Vi, dp.V_bias_gen_nmos, dp.vss, dp.MN1);
dp.MN2 = check_sat(dp.Vx, 0, dp.Vi, dp.MN1);
dp.MP3 = check_sat(dp.Vx, dp.V_bias_gen_pmos, dp.vdd, dp.MP3);

dp.MP4 = check_sat(dp.Vw, dp.Vx, dp.vdd, dp.MP4);
dp.MP5 = check_sat(dp.Vy, 0, dp.Vw, dp.MP5);
dp.MN6 = check_sat(dp.Vy, dp.V_bias_gen_nmos, dp.vss, dp.MN6);

dp.MN7 = check_sat(dp.Vz, dp.Vy, dp.vss, dp.MN7);
dp.MP8 = check_sat(dp.Vz, dp.Vz, dp.vdd, dp.MP8);

dp.MN9 = check_sat(dp.Vo, dp.V_bias_gen_nmos, dp.vss, dp.MN9);
dp.MN10 = check_sat(dp.vdd, dp.Vz, dp.Vo, dp.MN10);

dp.all_sat = dp.MN1.sat_ok & dp.MN2.sat_ok & dp.MP3.sat_ok & dp.MP4.sat_ok & dp.MP5.sat_ok & ...
             dp.MN6.sat_ok & dp.MN7.sat_ok & dp.MP8.sat_ok & dp.MN9.sat_ok & dp.MN10.sat_ok;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute gms, caps and ros

dp.MN2 = calc_gm(dp.MN2);
dp.MP4 = calc_gm(dp.MP4);
dp.MN7 = calc_gm(dp.MN7);
dp.MP8 = calc_gm(dp.MP8);
dp.MN10 = calc_gm(dp.MN10);

dp.MN10 = calc_gmb(dp.vss, dp.Vo, dp.MN10);
dp.MN2 = calc_gmb(dp.vss, dp.Vi, dp.MN2);

dp.MN1 = calc_caps_sat(dp.MN1);
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

dp.R1 = calc_r_size(dp.R1);
dp.R2 = calc_r_size(dp.R2);
dp.R3 = calc_r_size(dp.R3);
dp.R4 = calc_r_size(dp.R4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stage 0 Iin -> Vin

dp.stages{1}.gain = 1;
dp.stages{1}.gain_db = 20 * log10(abs(dp.stages{1}.gain));
dp.stages{1}.c = dp.Cin + dp.MN2.cgs + dp.MN1.cgd + 20e-15;
dp.stages{1}.r = parallel_r(dp.MN1.ro, 1/dp.MN2.gm_prime);
dp.stages{1} = calculate_stage_speed(dp.stages{1});
dp.stages{1}.pow = 0;
dp.stages{1}.name = 'Vi';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stage 1 Vin -> dp.Vx

dp.stages{2}.gain = parallel_r(dp.R1.val, dp.R2.val);
dp.stages{2}.gain_db = 20 * log10(abs(dp.stages{2}.gain));
dp.stages{2}.c = dp.MP4.cgs + dp.MN2.cgd + dp.MP3.cgd;
dp.stages{2}.r = parallel_r(dp.R1.val, dp.R2.val, dp.MP3.ro, dp.MN2.gm * dp.MN2.ro * dp.MN1.ro);
dp.stages{2} = calculate_stage_speed(dp.stages{2});
dp.stages{2}.pow = dp.MN1.id * (dp.vdd-dp.vss) + dp.vdd^2 / (dp.R1.val+dp.R2.val);
dp.stages{2}.name = 'Vx';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stage 2 dp.Vx -> dp.Vy

dp.stages{3}.gain = -dp.MP4.gm * parallel_r(dp.R3.val, dp.R4.val);
dp.stages{3}.gain_db = 20 * log10(abs(dp.stages{3}.gain));
dp.stages{3}.c = dp.MN7.cgs + dp.MP5.cgd + dp.MN6.cgd;
dp.stages{3}.r = parallel_r(dp.R3.val, dp.R4.val, dp.MN6.ro);
dp.stages{3} = calculate_stage_speed(dp.stages{3});
dp.stages{3}.pow = dp.MN6.id * (dp.vdd-dp.vss) + dp.vss^2 / (dp.R3.val+dp.R4.val);
dp.stages{3}.name = 'Vy';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stage 3 dp.Vy -> dp.Vz

dp.stages{4}.gain = -dp.MN7.gm / dp.MP8.gm;
dp.stages{4}.gain_db = 20 * log10(abs(dp.stages{4}.gain));
dp.stages{4}.c = dp.MP8.cgs + dp.MN10.cgs;
dp.stages{4}.r = 1 / dp.MP8.gm;
dp.stages{4} = calculate_stage_speed(dp.stages{4});
dp.stages{4}.pow = dp.MN7.id * (dp.vdd-dp.vss);
dp.stages{4}.name = 'Vz';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stage 4 dp.Vz -> dp.Vo

dp.stages{5}.Rl_tot = parallel_r(dp.Rl, 1/dp.MN10.gmb, dp.MN10.ro);
dp.stages{5}.gain = dp.MN10.gm / (dp.MN10.gm + 1/dp.stages{5}.Rl_tot);
dp.stages{5}.gain_db = 20 * log10(abs(dp.stages{5}.gain));
dp.stages{5}.c = dp.MN9.cgd + dp.Cl;
dp.stages{5}.r = parallel_r(dp.Rl, 1/dp.MN10.gmb, 1/dp.MN10.gm);
dp.stages{5} = calculate_stage_speed(dp.stages{5});
dp.stages{5}.pow = dp.MN9.id * (dp.vdd-dp.vss) + dp.Vo^2 / (dp.Rl);
dp.stages{5}.name = 'Vo';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Total Gain

stages = {dp.stages{1}, dp.stages{2}, dp.stages{3}, dp.stages{4}, dp.stages{5}};

dp.total.gain = 1;
for i = 1:length(stages)
  dp.total.gain = dp.total.gain * stages{i}.gain;
end
dp.total.gain_db = 20 * log10(abs(dp.total.gain));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Power

dp.total.pow = 0;
for i = 1:length(stages)
  dp.total.pow = dp.total.pow + stages{i}.pow;
end

dp.total.t = 0;
for i = 1:length(stages)
  dp.total.t = dp.total.t + stages{i}.t;
end
dp.total.f = 1 / (2 * pi() * dp.total.t);

dp.total.fom = dp.total.f/1e6 * dp.total.gain/1e3 * (1e-3 / dp.total.pow);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Requirements

trans = {dp.MN1, dp.MN2, dp.MP3, dp.MP4, dp.MP5, dp.MN6, dp.MN7, dp.MP8, dp.MN9, dp.MN10};

if print_warnings

  % Check Saturation
  for i = 1:length(trans)
    if not(trans{i}.sat_ok)
      warning('Transistor %s not in saturation!', trans{i}.name);
    end
  end

  % Check Total Gain
  min_gain = 90;
  if dp.total.gain_db < min_gain
    warning('Total gain too low, %0.1f < %0.1f', dp.total.gain_db, min_gain);
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
  if dp.total.pow > max_pow
    warning('Total power too high, %0.1f > %0.1f', dp.total.pow*1e3, max_pow*1e3);
  end

  % Check Figure Of Merit
  min_fom = 1350;
  if dp.total.fom < min_fom
    warning('Figure of Merit too low, %0.0f < %0.0f', dp.total.fom, min_fom);
  end
  
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make Interesting Plots
if make_plots
  
  plot_stages(stages);

end