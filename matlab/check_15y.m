function check_15y(dp)
  bias = dp.MN1.w/dp.MN1.l + dp.MP3.w/dp.MP3.l +dp.MN6.w/dp.MN6.l +dp.MN9.w/dp.MN9.l;
  gen = dp.MN300.w / dp.MN300.l;
  
  if bias > (gen * 15)
    warning('Bias widths are too large!');
  

end