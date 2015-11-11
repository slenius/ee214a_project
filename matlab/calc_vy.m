function vy = calc_vy(vz, dp)
  vy = (sqrt((dp.MP8.w / dp.MP8.l) / (2 * (dp.MN7.w/dp.MN7.l))) * ...
        dp.vdd - vz - abs(dp.ee214a.Vtp0)) + dp.vss + dp.ee214a.Vtn0;
end