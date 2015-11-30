function t = calc_caps_sat(t)
  % assuming transistor in saturation
  Cox = 2.3e-3;
  Cov_prime = 0.5e-9;
  
  t.cov = Cov_prime * t.w;
  t.cgs = 2/3 * t.w * t.l * Cox + t.cov;
  t.cgd = t.cov;
  t.cdb = 0.33 * t.cgs;
  t.csb = 0.33 * t.cgs;
end