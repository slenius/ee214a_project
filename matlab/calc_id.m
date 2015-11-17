function t = calc_id(vd, vg, vs, t)
  t = check_sat(vd, vg, vs, t);
  t.vov = t.vgs - t.vt;
  if strcmp(t.mode, 'saturation')
    t = calc_idsat(t);
    t.ro_tri = inf;
  elseif strcmp(t.mode, 'triode')
    t = calc_idtri(vd, vg, vs, t);
    t = calc_rotri(vd, vg, vs, t);
  else
    % cutoff
    t.id = 0;
    t.ro = inf;
    t.ro_tri = inf;
  end
  t = calc_ro(t);
  t.ro = parallel_r(t.ro, t.ro_tri);
end