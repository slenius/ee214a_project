function w9 = compute_mn9_size(w10, l10, l9, Vz, Vnbias)
  % compute the vt for mn10
  mn10.w = w10;
  mn10.l = l10;
  mn10.vt0 = 0.5;
  
  %using Vo = -0.15V as a hack to get more vov.
  mn10 = calc_vt(-0.15, -2.5, mn10);
  
  vov10 = Vz - mn10.vt + 0.15;
  vov9 = Vnbias + 2.5 - 0.5;
  
  w9 = l9 * w10 / l10 * vov10^2 / vov9^9;
  w9 = min(w9, 256);
  w9 = max(w9, 2);

end