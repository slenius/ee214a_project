function t = calc_rotri(vd, vg, vs, t)

  epsilon = 0.001;
  v1 = vd - epsilon;
  v2 = vd + epsilon;
  t1 = calc_idtri(v1, vg, vs, t);
  t2 = calc_idtri(v2, vg, vs, t);
  i1 = t1.id;
  i2 = t2.id;
  t.ro_tri = (v2 - v1) / (i2 - i1);

end