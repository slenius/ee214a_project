function t = calc_idsat(t)
  t.id = 1/2 * t.k * t.vov ^2;
  t.ro_tri = inf;
end