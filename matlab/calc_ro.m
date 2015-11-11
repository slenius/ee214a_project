function t = calc_ro(t)
  lambda = 0.1e-6 / t.l;
  t.ro = 1 / (lambda * t.id);
end