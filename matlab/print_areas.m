function dp = print_areas(dp)
  dp.a_nmos = sum_mos_area(dp.MN1, dp.MN2, dp.MN6, dp.MN7, dp.MN10, dp.MN9);
  dp.a_pmos = sum_mos_area(dp.MP3, dp.MP4, dp.MP5, dp.MP8);
  dp.a_res = dp.R1.size + dp.R2.size + dp.R3.size + dp.R4.size;
  dp.core_area = sum_mos_area(dp.MN2, dp.MP4, dp.MP5, dp.MN7, dp.MP8, dp.MN10) + dp.a_res;
  dp.a_nmos_bias = sum_mos_area(dp.MN1, dp.MN6, dp.MN9);
  dp.a_pmos_bias = sum_mos_area(dp.MP3);
  
  pie(1e6*[dp.a_nmos dp.a_pmos dp.a_res])
  title('Design Area Fraction Breakdown')
  legend('NMOS', 'PMOS', 'Resistor');
  
  % Bias generator areas
  dp.b_nmos = sum_mos_area(dp.MN300, dp.MN400);
  dp.b_pmos = sum_mos_area(dp.MP100, dp.MP200);
  dp.b_total = sum_mos_area(dp.MP100, dp.MP200, dp.MN300, dp.MN400, dp.MN700, dp.MP800, dp.MN900);
  
  
  core = dp.core_area*1e6
  vnmos_bias= 1e6 * dp.a_nmos_bias
  vpmos_bias= 1e6 * dp.a_pmos_bias
  bias_gen= 1e6 * dp.b_total
  
  vnmos_bias_percent = 100 * dp.a_nmos_bias / dp.core_area
  vpmos_bias_percent = 100 * dp.a_pmos_bias / dp.core_area
  bias_gen_percent = 100 * dp.b_total / dp.core_area
  
  
end