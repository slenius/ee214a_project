function score = evaluate_candidate(x, dbg)

  vov = x(1);
  stage_1 = x(2);
  stage_2 = x(3);
  stage_3 = x(4);
  stage_4 = x(5);
  rg1 = x(6);
  rg2 = x(7);

  dp = load_defaults(vov, stage_1, stage_2, stage_3, stage_4, rg1, rg2);
  
  
  dp = design_project(dp, false, false);

  if dp.total.gain_db >= 90
    gain_score = 1;
  elseif dp.total.gain_db > 30
    gain_score = (dp.total.gain_db / 90) * 0.75;
  else
    gain_score = 0;
  end  
  
  if dp.total.pow > 2e-3
    power_score = 0;
  else
    power_score = 1 - dp.total.pow / 2e-3;
  end
  

  if dp.total.f > 90e6
    freq_score = 1;
  elseif dp.total.f > 20
    freq_score = (dp.total.f / 90e6) * 0.75;
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