function t = calc_gm(t)
  if t.sat_ok
    t.gm = sqrt(2 * t.id * t.uCox * t.w / t.l);
  else
    t.gm = 0;
  end
end