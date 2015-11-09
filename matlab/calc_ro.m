function t = calc_ro(t)
  lambda = 0.1e6 * t.w;
  t.ro = 1 / (lambda * t.id);
end