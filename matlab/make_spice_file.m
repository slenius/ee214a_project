function make_spice_file(dp, fname, bias)
  f = fopen(fname, 'w+');
  fprintf(f, '* autogenerated spice file, vov = %0.3f\n', dp.vov);
  fprintf(f, '.include /usr/class/ee114/hspice/ee114_hspice.sp\n');
  fprintf(f, 'vdd     n_vdd   0       2.5\n');
  fprintf(f, 'vss     n_vss   0       -2.5\n');
  fprintf(f, 'Iin     n_iin   0       ac      1\n');
  
  fprintf(f, 'RL      n_vout  0       %d\n', dp.Rl);
  fprintf(f, 'CL      n_vout  0       %df\n', dp.Cl*1e15);
  fprintf(f, 'Cin     n_iin   0       %df\n', dp.Cin*1e15);
  
  fprintf(f, 'MN1     n_iin   n_bias_n  n_vss   n_vss nmos114 w=%0.1fu l=%0.1fu\n', dp.MN1.w*1e6, dp.MN1.l*1e6);
  fprintf(f, 'MN2     n_x     0         n_iin  n_vss  nmos114 w=%0.1fu l=%0.1fu\n', dp.MN2.w*1e6, dp.MN2.l*1e6);
  fprintf(f, 'MP3     n_x     n_bias_p  n_vdd  n_vdd  pmos114 w=%0.1fu l=%0.1fu\n', dp.MP3.w*1e6, dp.MP3.l*1e6);
  fprintf(f, 'MP4     n_w     n_x       n_vdd  n_vdd  pmos114 w=%0.1fu l=%0.1fu\n', dp.MP4.w*1e6, dp.MP4.l*1e6);
  fprintf(f, 'MP5     n_y     0         n_w    n_vdd  pmos114 w=%0.1fu l=%0.1fu\n', dp.MP5.w*1e6, dp.MP5.l*1e6);
  fprintf(f, 'MN6     n_y     n_bias_n  n_vss  n_vss  nmos114 w=%0.1fu l=%0.1fu\n', dp.MN6.w*1e6, dp.MN6.l*1e6);
  fprintf(f, 'MN7     n_z     n_y       n_vss  n_vss  nmos114 w=%0.1fu l=%0.1fu\n', dp.MN7.w*1e6, dp.MN7.l*1e6);
  fprintf(f, 'MP8     n_z     n_z       n_vdd  n_vdd  pmos114 w=%0.1fu l=%0.1fu\n', dp.MP8.w*1e6, dp.MP8.l*1e6);
  fprintf(f, 'MN9     n_vout  n_bias_n  n_vss  n_vss  nmos114 w=%0.1fu l=%0.1fu\n', dp.MN9.w*1e6, dp.MN9.l*1e6);
  fprintf(f, 'MN10    n_vdd   n_z       n_vout n_vss  nmos114 w=%0.1fu l=%0.1fu\n', dp.MN10.w*1e6, dp.MN10.l*1e6);
  
  rnd = 100;
  fprintf(f, 'R1      n_vdd   n_x       %d\n', round(dp.R1.val/rnd)*rnd);
  fprintf(f, 'R2      n_x     0         %d\n', round(dp.R2.val/rnd)*rnd);
  fprintf(f, 'R3      n_y     0         %d\n', round(dp.R3.val/rnd)*rnd);
  fprintf(f, 'R4      n_y     n_vss     %d\n', round(dp.R4.val/rnd)*rnd);
  
  if bias
    fprintf(f, 'MP100   n_bias_n n_bias_p n_vdd n_vdd  pmos114 w=4u  l=2u\n');
    fprintf(f, 'MP200   n_bias_p n_bias_p n_vdd n_vdd  pmos114 w=4u  l=2u\n');
    fprintf(f, 'MN300   n_bias_n n_bias_n n_vss n_vss  nmos114 w=2u  l=2u\n');
    fprintf(f, 'MN400   n_bias_p n_bias_n n_biasr2   n_vss  nmos114 w=4u l=2u\n');
    fprintf(f, 'R200    n_biasr2 n_vss  11.2k\n');
    fprintf(f, 'MP800   n_biasn9 n_bias_n n_vdd n_vdd pmos114 w=2u  l=4u\n');
    fprintf(f, 'MN700   n_biasn9 n_bias_n n_vss n_vss nmos114 w=5u  l=2u\n');
    fprintf(f, 'MN900   n_bias_p n_biasn9 n_vss n_vss nmos114 w=4u  l=2u\n');
  else
    fprintf(f, 'v_bias_n n_bias_n n_vss %f\n', dp.V_bias_gen_nmos - dp.vss);
    fprintf(f, 'v_bias_p n_bias_p n_vdd %f\n', -(dp.vdd - dp.V_bias_gen_pmos));
  end

  fprintf(f, '.op\n');
  fprintf(f, '.option post brief nomod\n');

  fprintf(f, '.ac dec 1k 100 1g\n');
  fprintf(f, '.pz v(n_vout) Iin\n');

  fprintf(f, '.measure ac gainmax_vin max vdb(n_iin)\n');
  fprintf(f, '.measure ac f3db_vin when vdb(n_iin)="gainmax_vin-3"\n');

  fprintf(f, '.measure ac gainmax_vx max vdb(n_x)\n');
  fprintf(f, '.measure ac f3db_vx when vdb(n_x)="gainmax_vx-3"\n');

  fprintf(f, '.measure ac gainmax_vw max vdb(n_w)\n');
  fprintf(f, '.measure ac f3db_vw when vdb(n_w)="gainmax_vw-3"\n');

  fprintf(f, '.measure ac gainmax_vy max vdb(n_y)\n');
  fprintf(f, '.measure ac f3db_vy when vdb(n_y)="gainmax_vy-3"\n');

  fprintf(f, '.measure ac gainmax_vz max vdb(n_z)\n');
  fprintf(f, '.measure ac f3db_vz when vdb(n_z)="gainmax_vz-3"\n');

  fprintf(f, '.measure ac gainmax_vout max vdb(n_vout)\n');
  fprintf(f, '.measure ac f3db_vout when vdb(n_vout)="gainmax_vout-3"\n');
  fprintf(f, '.end\n');
  fclose(f);

end