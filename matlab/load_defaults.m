function dp = load_defaults(vov, stage_1, stage_2, stage_3, stage_4, rg1, rg2)

  % EE214 Parameters
  dp.ee214a.unCox = 50e-6;
  dp.ee214a.upCox = 25e-6;
  dp.ee214a.Vtn0 = 0.5;
  dp.ee214a.Vtp0 = -0.5;

  % Design Project Parameters
  dp.Rl = 20e3;
  dp.Cl = 250e-15;
  dp.Cin = 220e-15;
  
  dp.vdd = 2.5;
  dp.vss = -2.5;
  
  dp.vov = vov;
  
  dp.Vx_goal = dp.vdd + dp.ee214a.Vtp0 - dp.vov;
  dp.r_eq_1 = rg1;
  [dp.R1.val, dp.R2.val] = calc_rt_rb(dp.vdd, 0, dp.Vx_goal, dp.r_eq_1);
  
  dp.Vy_goal = dp.vss + dp.ee214a.Vtn0 + dp.vov;
  dp.r_eq_2 = rg2;
  [dp.R3.val, dp.R4.val] = calc_rt_rb(0, dp.vss, dp.Vy_goal, dp.r_eq_2);
  

  %dp.R4 = dp.r_eq_2 / (dp.ee214a.Vtn0 + vov);
  %dp.R3 = dp.R4 * dp.r_eq_2 / (dp.R4 - dp.r_eq_2);

  % Vy goal - 1.95V
  %dp.R4 = dp.r_eq_2 / (-1.95+2.5);
  %dp.R3 = dp.R4 * dp.r_eq_2 / (dp.R4 - dp.r_eq_2);
  
  % Transistor Definitions
  dp.MN1.type = 'nmos';
  dp.MN2.type = 'nmos';
  dp.MP3.type = 'pmos';
  dp.MP4.type = 'pmos';
  dp.MP5.type = 'pmos';
  dp.MN6.type = 'nmos';
  dp.MN7.type = 'nmos';
  dp.MP8.type = 'pmos';
  dp.MN9.type = 'nmos';
  dp.MN10.type = 'nmos';

  dp.MN1.name = 'MN1';
  dp.MN2.name = 'MN2';
  dp.MP3.name = 'MP3';
  dp.MP4.name = 'MP4';
  dp.MP5.name = 'MP5';
  dp.MN6.name = 'MN6';
  dp.MN7.name = 'MN7';
  dp.MP8.name = 'MP8';
  dp.MN9.name = 'MN9';
  dp.MN10.name = 'MN10';

  dp.MN1.uCox = dp.ee214a.unCox;
  dp.MN2.uCox = dp.ee214a.unCox;
  dp.MP3.uCox = dp.ee214a.upCox;
  dp.MP4.uCox = dp.ee214a.upCox;
  dp.MP5.uCox = dp.ee214a.upCox;
  dp.MN6.uCox = dp.ee214a.unCox;
  dp.MN7.uCox = dp.ee214a.unCox;
  dp.MP8.uCox = dp.ee214a.upCox;
  dp.MN9.uCox = dp.ee214a.unCox;
  dp.MN10.uCox = dp.ee214a.unCox;

  dp.MN1.vt0 = dp.ee214a.Vtn0;
  dp.MN2.vt0 = dp.ee214a.Vtn0;
  dp.MP3.vt0 = dp.ee214a.Vtp0;
  dp.MP4.vt0 = dp.ee214a.Vtp0;
  dp.MP5.vt0 = dp.ee214a.Vtp0;
  dp.MN6.vt0 = dp.ee214a.Vtn0;
  dp.MN7.vt0 = dp.ee214a.Vtn0;
  dp.MP8.vt0 = dp.ee214a.Vtp0;
  dp.MN9.vt0 = dp.ee214a.Vtn0;
  dp.MN10.vt0 = dp.ee214a.Vtn0;
  
  % Transistor sizing
  stage_1_size = stage_1 * 1e-6;
  stage_2_size = stage_2 * 1e-6;
  stage_3_size = stage_3 * 1e-6;
  stage_4_size = stage_4 * 1e-6;
  
  dp.MN1.w = stage_1_size;
  dp.MN1.l = 2e-6;

  dp.MN2.w = stage_1_size;
  dp.MN2.l = 2e-6;

  dp.MP3.w = stage_1_size * 2;
  dp.MP3.l = 2e-6;
  
  dp.MP4.w = stage_2_size * 2;
  dp.MP4.l = 2e-6;

  dp.MP5.w = stage_2_size * 2;
  dp.MP5.l = 2e-6;

  dp.MN6.w = stage_2_size;
  dp.MN6.l = 2e-6;

  dp.MN7.w = stage_3_size;
  dp.MN7.l = 2e-6;

  dp.MP8.w = stage_3_size;
  dp.MP8.l = 2e-6;

  dp.MN9.w = stage_4_size;
  dp.MN9.l = 2e-6;

  dp.MN10.w = 8e-6;
  dp.MN10.l = 2e-6;

end