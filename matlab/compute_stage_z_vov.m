function vov_y = compute_stage_z_vov(f_z, w7, l7, w10, l10, n)
  cox = 2.3e-3;
  unCox = 50e-6;
  vov_y = (f_z *4/3 * pi() * sqrt(2) * cox * (n * w7 * l7 + w10 * l10)) / ...
        (unCox * w7/l7 * sqrt(n));
  f_z_check = (unCox * vov_y * w7/l7 * sqrt(n)) / ...
       (4 * pi() / 3 * sqrt(2) * cox * (n * w7 * l7 + w10 * l10));

end