function t = calc_gmb(vb, vs, t)

  phi = 0.8;
  gamma = 0.6;

  t.vbs = vb - vs;
  if (-2 * phi - t.vbs) > 0
    t.gmb = gamma * t.gm / (2 * sqrt(-2 * phi - t.vbs));
  else
    t.gmb = 0;
  end
end