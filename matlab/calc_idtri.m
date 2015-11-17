function t = calc_idtri(vd, vg, vs, t)
  t.vgs = vg - vs;
  t.vds = vd - vs;
  t.id = t.uCox * (t.w / t.l) * ((t.vgs - t.vt) - t.vds/2) * t.vds;
  t =  check_sat(vd, vg, vs, t);
  if t.sat_ok
    warning('Transistor %s not in triode!', t.name);
  end
  
  
end