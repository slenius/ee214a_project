function [rt, rb] = calc_rt_rb(vt, vb, vo, req)
  rt = req * (vt - vo) / (vo - vb) + req;
  rb = rt / ((vt - vo) / (vo - vb));
end