function plot_stages(stages)

  figure;
  for i = 1:length(stages)
    y(i) = stages{i}.t * 1e9;
    x(i) = i-1;
  end
  plot(x, y, 'b*-')
  title('Stage Tau Contributions')
  xlabel('Stage');
  ylabel('Tau (ns)');
  
  figure;
  hold on;
  last = 0;
  for i = 1:length(stages)
    y1(i) = stages{i}.pow * 1e6;
    y2(i) = last + y1(i);
    x(i) = i-1;
    last = y2(i);
  end
  plot(x, y1, 'b*-')
  plot(x, y2, 'r*-')
  title('Stage Power Contributions')
  xlabel('Stage');
  ylabel('Power (uw)');
  legend('Stage Power', 'Total Power');
  
  
  figure;
  hold on;
  last = 0;
  for i = 1:length(stages)
    y1(i) = stages{i}.gain_db;
    y2(i) = last + y1(i);
    last = y2(i);
    x(i) = i-1;
  end
  plot(x, y1, 'b*-')
  plot(x, y2, 'r*-')
  legend('Stage Gain', 'Total Gain');
  title('Stage Gain Contributions')
  xlabel('Stage');
  ylabel('Gain (dB)');
  
end