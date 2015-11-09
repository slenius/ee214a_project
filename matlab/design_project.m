clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% EE214 Parameters
unCox = 50e-6;
upCox = 25e-6;
Vtn0 = 0.5;
Vtp0 = -0.5;

% Design constants
Vdd = 2.5;
Vss = -2.5;
VGnd = 0;
Rl = 20e3;
Cl = 250e-15;
Cin = 220e-15;

% Inputs
vov = 0.2;

V_bias_gen_pmos = Vdd - vov + Vtp0;
V_bias_gen_nmos = Vss + vov + Vtn0;

R_eq1 = 6.25e3;
R_eq2 = 6.25e3;

R1 = R_eq1 / (Vtn0 + vov);
R2 = R1 * R_eq1 / (R1 - R_eq1);

R4 = R_eq2 / (Vtn0 + vov);
R3 = R4 * R_eq2 / (R4 - R_eq2);

% Transistor Definitions
MN1.type = 'nmos';
MN2.type = 'nmos';
MP3.type = 'pmos';
MP4.type = 'pmos';
MP5.type = 'pmos';
MN6.type = 'nmos';
MN7.type = 'nmos';
MP8.type = 'pmos';
MN9.type = 'nmos';
MN10.type = 'nmos';

MN1.name = 'MN1';
MN2.name = 'MN2';
MP3.name = 'MP3';
MP4.name = 'MP4';
MP5.name = 'MP5';
MN6.name = 'MN6';
MN7.name = 'MN7';
MP8.name = 'MP8';
MN9.name = 'MN9';
MN10.name = 'MN10';

MN1.uCox = unCox;
MN2.uCox = unCox;
MP3.uCox = upCox;
MP4.uCox = upCox;
MP5.uCox = upCox;
MN6.uCox = unCox;
MN7.uCox = unCox;
MP8.uCox = upCox;
MN9.uCox = unCox;
MN10.uCox = unCox;

MN1.vt = Vtn0;
MN2.vt = 0.870; % from spice
MP3.vt = Vtp0;
MP4.vt = Vtp0; 
MP5.vt = -.834; % from spice
MN6.vt = Vtn0;
MN7.vt = Vtn0;
MP8.vt = Vtp0;
MN9.vt = Vtn0;
MN10.vt = 1.0609; % from spice

% Transistor sizing
MN1.w = 2e-6;
MN1.l = 2e-6;

MN2.w = 2e-6;
MN2.l = 2e-6;

MP3.w = 2e-6;
MP3.l = 2e-6;

MP4.w = 2e-6;
MP4.l = 2e-6;

MP5.w = 2e-6;
MP5.l = 2e-6;

MN6.w = 2e-6;
MN6.l = 2e-6;

MN7.w = 2e-6;
MN7.l = 2e-6;

MP8.w = 2e-6;
MP8.l = 2e-6;

MN9.w = 2e-6;
MN9.l = 2e-6;

MN10.w = 2e-6;
MN10.l = 2e-6;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute k values

MN1 = calc_k(MN1);
MN2 = calc_k(MN2);
MP3 = calc_k(MP3);
MP4 = calc_k(MP4);
MP5 = calc_k(MP5);
MN6 = calc_k(MN6);
MN7 = calc_k(MN7);
MP8 = calc_k(MP8);
MN9 = calc_k(MN9);
MN10 = calc_k(MN10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute what we can for bias transistors

MN1.vov = V_bias_gen_nmos - MN1.vt - Vss;
MP3.vov = Vdd - V_bias_gen_pmos + MP3.vt;
MN6.vov = V_bias_gen_nmos - MN6.vt - Vss;
MN9.vov = V_bias_gen_nmos - MN9.vt - Vss;

MN1 = calc_idsat(MN1);
MP3 = calc_idsat(MP3);
MN2.id = MN1.id;

MN6 = calc_idsat(MN6);
MN9 = calc_idsat(MN9);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve for DC op points

% Stage 1
Vi = -sqrt(MN1.k) * MN1.vov / sqrt(MN2.k) - MN2.vt;
Vx = (MP3.id - MN1.id + Vdd / R1) * R_eq1;
   
% Stage 2
MP4.vov = Vx - Vdd - MP4.vt;
MP4 = calc_idsat(MP4);
MP5.id = MP4.id;

Vw = -sqrt(MP4.k) * MP4.vov / sqrt(MP5.k) - MP5.vt;
Vy = (MP4.id - MN6.id + Vss / R4) * R_eq2;

% Stage 3
MN7.vov = Vy - Vss - MN7.vt;
MN7 = calc_idsat(MN7);
MP8.id = MN7.id;

Vz = (sqrt(MP8.k) * (Vdd + MP8.vt) - sqrt(MN7.k) * MN7.vov) / sqrt(MP8.k);

% Stage 4
Vo = -Rl * (MN10.k * (MN10.vt - Vz) + MN9.k * MN9.vov^2) / ...
           (MN10.k * Rl + 2);

MN10 = calc_vov(Vz, Vo, MN10);
MN10 = calc_idsat(MN10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check requirements for saturation

MN1 = check_sat(Vi, V_bias_gen_nmos, Vss, MN1);
MN2 = check_sat(Vx, 0, Vi, MN1);
MP3 = check_sat(Vx, V_bias_gen_pmos, Vdd, MP3);

MP4 = check_sat(Vw, Vx, Vdd, MP4);
MP5 = check_sat(Vy, 0, Vw, MP5);
MN6 = check_sat(Vy, V_bias_gen_nmos, Vss, MN6);

MN7 = check_sat(Vz, Vy, Vss, MN7);
MP8 = check_sat(Vz, Vz, Vdd, MP8);

MN9 = check_sat(Vo, V_bias_gen_nmos, Vss, MN9);
MN10 = check_sat(Vdd, Vz, Vo, MN10);

all_sat = MN1.sat_ok & MN2.sat_ok & MP3.sat_ok & MP4.sat_ok & MP5.sat_ok & ...
          MN6.sat_ok & MN7.sat_ok & MP8.sat_ok & MN9.sat_ok & MN10.sat_ok;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute gms, caps and ros

MN2 = calc_gm(MN2);
MP4 = calc_gm(MP4);
MN7 = calc_gm(MN7);
MP8 = calc_gm(MP8);
MN10 = calc_gm(MN10);

MN2 = calc_caps_sat(MN2);
MP3 = calc_caps_sat(MP3);
MP4 = calc_caps_sat(MP4);
MP5 = calc_caps_sat(MP5);
MN6 = calc_caps_sat(MN6);
MN7 = calc_caps_sat(MN7);
MP8 = calc_caps_sat(MP8);
MN9 = calc_caps_sat(MN9);
MN10 = calc_caps_sat(MN10);

MN1 = calc_ro(MN1);
MN2 = calc_ro(MN2);
MP3 = calc_ro(MP3);
MP4 = calc_ro(MP4);
MN6 = calc_ro(MN6);
MN7 = calc_ro(MN7);
MP8 = calc_ro(MP8);
MN9 = calc_ro(MN9);
MN10 = calc_ro(MN10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stage 0 Iin -> Vin

stage_0.gain = 1;
stage_0.gain_db = 20 * log10(abs(stage_0.gain));
stage_0.c = Cin + MN2.cgs;
stage_0.r = parallel_r(MN1.ro, 1/MN2.gm);
stage_0 = calculate_stage_speed(stage_0);
stage_0.pow = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stage 1 Vin -> Vx

stage_1.gain = parallel_r(R1, R2);
stage_1.gain_db = 20 * log10(abs(stage_1.gain));
stage_1.c = MP4.cgs + MN2.cgd + MP3.cgd;
stage_1.r = parallel_r(R1, R2, MP3.ro, MN2.gm * MN2.ro * MN1.ro);
stage_1 = calculate_stage_speed(stage_1);
stage_1.pow = MN1.id * (Vdd-Vss) + Vdd^2 / (R1+R2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stage 2 Vx -> Vy

stage_2.gain = -MP4.gm * parallel_r(R3, R4);
stage_2.gain_db = 20 * log10(abs(stage_2.gain));
stage_2.c = MN7.cgs + MP5.cgd + MN6.cgd;
stage_2.r = parallel_r(R3, R4, MN6.ro);
stage_2 = calculate_stage_speed(stage_2);
stage_2.pow = MN6.id * (Vdd-Vss) + Vss^2 / (R3+R4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stage 3 Vy -> Vz

stage_3.gain = -MN7.gm / MP8.gm;
stage_3.gain_db = 20 * log10(abs(stage_3.gain));
stage_3.c = MP8.cgs + MN10.cgs;
stage_3.r = 1 / MP8.gm;
stage_3 = calculate_stage_speed(stage_3);
stage_3.pow = MN7.id * (Vdd-Vss);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stage 4 Vz -> Vo

stage_4.gain = MN10.gm * Rl;
stage_4.gain_db = 20 * log10(abs(stage_4.gain));
stage_4.c = MN9.cgd + Cl;
stage_4.r = Rl;
stage_4 = calculate_stage_speed(stage_4);
stage_4.pow = MN9.id * (Vdd-Vss) + Vo^2 / (Rl);

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

trans = {MN1, MN2, MP3, MP4, MP5, MN6, MN7, MP8, MN9, MN10};

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make Interesting Plots

plot_stages(stages);

