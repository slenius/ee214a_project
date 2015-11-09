function transistor = calc_vov(vg, vs, transistor)
  transistor.vgs = vg - vs;
  transistor.vov = transistor.vgs - transistor.vt;
end