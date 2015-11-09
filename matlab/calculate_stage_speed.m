function stage = calculate_stage_speed(stage)
  stage.t = stage.r * stage.c;
  stage.f = 1 / (2 * pi() * stage.t);
end