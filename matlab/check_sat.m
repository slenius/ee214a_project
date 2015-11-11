function transistor = check_sat(vd, vg, vs, transistor)
  transistor.vgs = vg - vs;
  transistor.vds = vd - vs;
  if transistor.type == 'nmos'
    vgs_test_n = ge(transistor.vgs, transistor.vt);
    vds_test_n = ge(transistor.vds, transistor.vgs - transistor.vt);
    transistor.sat_ok = and(vgs_test_n, vds_test_n);
  else
    vgs_test_p = le(transistor.vgs, -transistor.vt);
    vds_test_p = le(transistor.vds, (transistor.vgs - transistor.vt));
    transistor.sat_ok = and(vgs_test_p, vds_test_p);
  end 
end