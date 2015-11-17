function score = sizeall(x, dbg)

  vov = x(1);

  dp = load_defaults(vov, 2, 2, 2, 2, 10000, 10000, 1);
  
  dp.vov = x(1);
  dp.MN1.w = x(2)*1e-6;
  dp.MN1.w = x(3)*1e-6;
  dp.MP3.w = x(4)*1e-6;
  dp.MP4.w = x(5)*1e-6;
  dp.MP5.w = x(6)*1e-6;
  dp.MN6.w = x(7)*1e-6;
  dp.MN7.w = x(8)*1e-6;
  dp.MP8.w = x(9)*1e-6;
  dp.MN9.w = x(10)*1e-6;
  dp.MN10.w = x(11)*1e-6;
  
  dp.R1.val = x(12);
  dp.R2.val = x(13);
  dp.R3.val = x(14);
  dp.R4.val = x(15);
  
  dp = design_project(dp, false, false);

  if dp.total.gain >= 32000
    gain_score = 1;
  elseif dp.total.gain > 1000
    gain_score = (dp.total.gain / 32000) * 0.75;
  else
    gain_score = 0;
  end  
  
  if dp.total.pow > 2e-3
    power_score = 0;
  else
    power_score = 1 - dp.total.pow / 2e-3;
  end
  

  if dp.total.f > 70e6
    freq_score = 1;
  elseif dp.total.f > 20
    freq_score = (dp.total.f / 70e6) * 0.75;
  else
    freq_score = 0;
  end
  
  if abs(dp.Vo) < 0.15
    cmv_score = 1;
  else
    cmv_score = 0;
  end
  
  if dbg
    gain_score
    power_score
    freq_score
    cmv_score
  end
  
  if freq_score == 0
    score = 0;
  elseif gain_score == 0
    score = 0;
  elseif dp.all_sat == 0
    score = 0;
  else 
    score = (power_score*0 + gain_score*.3 + freq_score*.7 + cmv_score*0);
    
end