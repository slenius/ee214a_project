function r = compute_stage_x_res(speed, w1, l1, w2, l2)
  cox = 2.3e-3;
  cov_prime = 0.5e-9;

  cgd = 3 * cov_prime * w1;
  cgs = 2/3 * cox * w2 * l2 + cov_prime * w2;
  cdb = (2/3 * cox * w1 * l1 + cov_prime * w2) / 3;
  cx = cgd + cgs + cdb;
 
  req = 1 / (2 * pi() * speed * cx);
  ro = 177e3;
  
  r = req / (1 - req/ro);
end