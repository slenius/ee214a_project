function w = compute_stage_i_size(speed, vov)
  cox = 2.3e-3;
  cov_prime = 0.5e-9;
  unCox = 50e-6;
  cin = 2.2e-13;
  L = 2e-6;
  n = 6;
  
  % given vov ,speed and L, solve for W

  a = 1 / (2 * pi * speed);
  b = ((1 + 1/3) * 2/3 * L^2 * cox + L * cov_prime) / (n *unCox * vov);
  w = cin * L / (unCox * vov * (a-b));
  
  % round to nearest 0.2um and clip at 2um and 128um
  w = round(w/0.2e-6) * 0.2e-6;
  w = min(w, 32e-6);
  w = max(w, 2e-6);
  
  w = w * 1e6;
end