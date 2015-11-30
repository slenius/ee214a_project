function r = compute_stage_y_res(speed, w6, l6, w7, l7)
  cox = 2.3e-3;
  cov_prime = 0.5e-9;

  cgd = 3 * cov_prime * w6;
  cgs = 2/3 * cox * w7 * l7 + cov_prime * w7;
  cdb = 2/3 * cox * w6 * l6 + cov_prime * w6;
  cy = cgd + cgs + cdb;
 
  req = 1 / (2 * pi() * speed * cy);
  ro = 177e3;
  
  r = req / (1 - req/ro);
end