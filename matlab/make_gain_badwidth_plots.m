close all
clear all

vov = 0.15:0.05:1.0;

for i = 1:length(vov)
  dp = design_project(load_defaults(vov(i), 8, 8, 2, 16, 10000, 22500, 1), false, false);
  
  for stage = 1:5
    if dp.all_sat
      stage_speed(i, stage) = dp.stages{stage}.f;
      stage_gain_db(i, stage) = dp.stages{stage}.gain_db;
    else
      stage_speed(i, stage) = nan;
      stage_gain_db(i, stage) = nan;
    end
    stage_names{stage} = dp.stages{stage}.name;
  end
  stage_names{6} = 'Total';
  if dp.all_sat
    stage_gain_db(i, 6) = dp.total.gain_db;
    stage_speed(i, 6) = dp.total.f;
  else
    stage_gain_db(i, 6) = nan;
    stage_speed(i, 6) = nan;
  end
  
end

figure;
plot(vov, stage_speed./1e6);
xlabel('vov');
ylabel('Stage Speed (Mhz)');
legend(stage_names);

figure;
plot(vov, stage_gain_db);
xlabel('vov');
ylabel('Stage Gain (dB)');
legend(stage_names);
