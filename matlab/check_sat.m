function transistor = check_sat(vd, vg, vs, transistor)
  transistor.vgs = vg - vs;
  transistor.vds = vd - vs;
  if transistor.type == 'nmos'   
    vgs_test = ge(transistor.vgs, transistor.vt);
    vds_test = ge(transistor.vds, transistor.vgs - transistor.vt);
    transistor.sat_ok = and(vgs_test, vds_test);
  else
    vgs_test = le(transistor.vgs, -transistor.vt);
    vds_test = le(transistor.vds, (transistor.vgs - transistor.vt));
    transistor.sat_ok = and(vgs_test, vds_test);
  end 
  if vgs_test
    if vds_test
      transistor.sat_ok = true;
      transistor.mode = 'saturation';
    else
      transistor.mode = 'triode';
    end
  else
    transistor.mode = 'cutoff';
  end
      
end