function t = calc_vt(vs, vb, t)
  %spice parameter PHI = surface potential
  phi = 0.8;
  gamma = 0.6;
  t.vsb = vs - vb;
  t.vt = t.vt0 + gamma * (sqrt(2 * phi + t.vsb) - sqrt(2 * phi));
end