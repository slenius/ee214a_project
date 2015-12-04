% clear all
% close all
% 
% 
% vov = 0.70;
% speed_goal_i = 300e6;
% speed_goal_x = 300e6;
% speed_goal_y = 300e6;
% 
% vystep = 0:-0.025:-2.5;
% 
% for i = 1:length(vystep)
% 
%   s1 = 3;
%   s2 = 8;
%   s3 = 2;
%   s4 = 28;
%   n_z = 1;
%   vy_goal = vystep(i);
%   vx_goal = 1.3;
% 
%   dp = load_defaults(vov, s1, s2, s3, s4, 20000, 50000, n_z, vx_goal, vy_goal, s4);
%   rx = compute_stage_x_res(speed_goal_x, dp.MN2.w, dp.MN2.l, dp.MP4.w, dp.MP4.l);
%   ry = compute_stage_y_res(speed_goal_y, dp.MN6.w, dp.MN6.l, dp.MN7.w, dp.MN7.l);
%   dp = load_defaults(vov, s1, s2, s3, s4, rx, ry, n_z, vx_goal, vy_goal, s4);
%   dp = design_project(dp, false, false);
% 
%   if dp.all_sat
%     y(i) = dp.Vy;
%     z(i) = dp.Vz;
%     o(i) = dp.Vo;
%   else
%     y(i) = nan;
%     z(i) = nan;
%     o(i) = nan;
%   end
% end
% 
% figure('Position', [100, 100, 400, 300]);
% hold on;
% plot(z, o, 'b-');
% plot([min(z) max(z)], [0.15 0.15], 'r-');
% plot([min(z) max(z)], [-0.15 -0.15], 'r-');
% plot([1.0 1.0], [min(o) 0], 'm-');
% xlabel('V(Z)');
% ylabel('V(Output)');
% title('Output Common Mode Voltage vs V(Z)');
% legend('Common Mode Voltage', 'Spec+', 'Spec-', 'Goal V(Z)');
% 
% figure('Position', [100, 100, 400, 300]);
% hold on;
% plot(y, z, 'b-');
% plot([min(y) -1.3], [1 1], 'm-');
% plot([-1.3 -1.3], [min(z) 1], 'k-');
% xlabel('V(Y)');
% ylabel('V(Z)');
% title('V(Z) vs V(Y)');
% legend('V(Z) vs V(Y)', 'Goal V(Z)', 'Goal V(Y)');
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % MN2 Size Plot
% 
% clear all
% 
% vov = 0.70;
% s1step = 2:20;
% xgain = 10000;
% ygain = 20000;
% 
% for i = 1:length(s1step)
% 
%   s1 = s1step(i);
%   s2 = 6;
%   s3 = 2;
%   s4 = 28;
%   n_z = 1;
%   vy_goal = -1.2;
%   vx_goal = 1.3;
% 
%   dp = load_defaults(vov, s1, s2, s3, s4, xgain, ygain, n_z, vx_goal, vy_goal, s4);
%   %rx = compute_stage_x_res(speed_goal_x, dp.MN2.w, dp.MN2.l, dp.MP4.w, dp.MP4.l);
%   %ry = compute_stage_y_res(speed_goal_y, dp.MN6.w, dp.MN6.l, dp.MN7.w, dp.MN7.l);
%   %dp = load_defaults(vov, s1, s2, s3, s4, rx, ry, n_z, vx_goal, vy_goal, s4);
%   dp = design_project(dp, false, true);
% 
%   if dp.all_sat
%     mn2(i) = dp.MN2.w*1e6;
%     ti(i) = dp.stages{1}.t*1e9;
%     tx(i) = dp.stages{2}.t*1e9;
%     fi(i) = dp.stages{1}.f/1e6;
%     fx(i) = dp.stages{2}.f/1e6;
%     tsum(i) = ti(i) + tx(i);
%   else
%     mn2(i) = nan;
%     ti(i) = nan;
%     tx(i) = nan;
%     fi(i) = nan;
%     fx(i) = nan;
%     tsum(i) = nan;
%   end
% end
% 
% figure('Position', [100, 100, 400, 300]);
% hold on;
% plot(mn2, ti, 'b-');
% plot(mn2, tx, 'r-');
% plot(mn2, tsum, 'm-');
% plot([24 24], [0 min(tsum)], 'k-');
% xlabel('MN2 Width (um)');
% ylabel('Tau(ns)');
% title(sprintf('Taus vs MN2 Width for X Stage Gain = %d, Vov = %0.2f', xgain, vov));
% legend('Tau In', 'Tau X', 'Sum Tau', 'Selected MN2');
% 
% % figure('Position', [100, 100, 400, 300]);
% % hold on;
% % plot(mn2, fi, 'b-');
% % plot(mn2, fx, 'r-');
% % plot(mn2, tsum, 'm-');
% % xlabel('MN2 Width (um)');
% % ylabel('Frequency (MHz)');
% % title('Pole Frequency vs MN2 Width for X Stage Gain = 10000');
% % legend('Pole F In', 'Pole F X');
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % MP4 Size Plot
% 
% clear all
% 
% vov = 0.70;
% s2step = 2:20;
% xgain = 10000;
% ygain = 3;
% 
% for i = 1:length(s2step)
% 
%   s1 = 3;
%   s2 = s2step(i);
%   s3 = 2;
%   s4 = 28;
%   n_z = 1;
%   vy_goal = -1.2;
%   vx_goal = 1.3;
%   
%   vov4 = 2.0 - vx_goal;
%   id4 = 1/2 * 25e-6 * s2 * vov4^2;
%   gm = 2 * id4 / vov4;
%   ry(i) = 3 / gm;
%   
% 
%   dp = load_defaults(vov, s1, s2, s3, s4, xgain, ry(i), n_z, vx_goal, vy_goal, s4);
%   %rx = compute_stage_x_res(speed_goal_x, dp.MN2.w, dp.MN2.l, dp.MP4.w, dp.MP4.l);
%   %ry = compute_stage_y_res(speed_goal_y, dp.MN6.w, dp.MN6.l, dp.MN7.w, dp.MN7.l);
%   %dp = load_defaults(vov, s1, s2, s3, s4, rx, ry, n_z, vx_goal, vy_goal, s4);
%   dp = design_project(dp, false, true);
% 
%   if dp.all_sat
%     mp4(i) = dp.MP4.w*1e6;
%     gm4(i) = dp.MP4.gm;
%     ty(i) = dp.stages{3}.t*1e9;
%     tx(i) = dp.stages{2}.t*1e9;
%     fy(i) = dp.stages{3}.f/1e6;
%     fx(i) = dp.stages{2}.f/1e6;
%     gy(i) = dp.stages{3}.gain;
%     tsum(i) = ty(i) + tx(i);
%   else
%     mp4(i) = nan;
%     ty(i) = nan;
%     tx(i) = nan;
%     fy(i) = nan;
%     fx(i) = nan;
%     gy(i) = nan;
%     gm4(i) = nan;
%     tsum(i) = nan;
%   end
% end
% 
% figure('Position', [100, 100, 400, 300]);
% hold on;
% plot(mp4, tx, 'b-');
% plot(mp4, ty, 'r-');
% plot(mp4, tsum, 'm-');
% plot([6 6], [0 min(tsum)], 'k-');
% xlabel('MP4 Width (um)');
% ylabel('Tau(ns)');
% title(sprintf('Taus vs MP4 Width for Y Stage Gain = %0.1f, Vov = %0.2f', ygain, 2.0-vx_goal));
% legend('Tau X', 'Tau Y', 'Sum Tau');
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % MN10 Size Plot
% 
% clear all
% 
% vov = 0.70;
% s4step = 2:50;
% xgain = 10000;
% ygain = 3;
% 
% for i = 1:length(s4step)
% 
%   s1 = 3;
%   s2 = 6;
%   s3 = 2;
%   s4 = s4step(i);
%   n_z = 1;
%   vy_goal = -1.2;
%   vx_goal = 1.3;
%   
%   vov4 = 2.0 - vx_goal;
%   id4 = 1/2 * 25e-6 * s2 * vov4^2;
%   gm = 2 * id4 / vov4;
%   ry(i) = 3 / gm;
% 
%   dp = load_defaults(vov, s1, s2, s3, s4, xgain, ry(i), n_z, vx_goal, vy_goal, s4);
%   %rx = compute_stage_x_res(speed_goal_x, dp.MN2.w, dp.MN2.l, dp.MP4.w, dp.MP4.l);
%   %ry = compute_stage_y_res(speed_goal_y, dp.MN6.w, dp.MN6.l, dp.MN7.w, dp.MN7.l);
%   %dp = load_defaults(vov, s1, s2, s3, s4, rx, ry, n_z, vx_goal, vy_goal, s4);
%   dp = design_project(dp, false, true);
% 
%   if dp.all_sat
%     mn10(i) = dp.MN10.w*1e6;
%     tz(i) = dp.stages{4}.t*1e9;
%     to(i) = dp.stages{5}.t*1e9;
%     go(i) = dp.stages{5}.gain;
%     vo(i) = dp.Vo;
%     tsum(i) = to(i) + tz(i);
%   else
%     mn10(i) = nan;
%     tz(i) = nan;
%     to(i) = nan;
%     go(i) = nan;
%     vo(i) = nan;
%     tsum(i) = nan;
%   end
% end
% 
% figure('Position', [100, 100, 400, 300]);
% hold on;
% plot(mn10, tz, 'b-');
% plot(mn10, to, 'r-');
% plot(mn10, tsum, 'm-');
% plot([10 10], [0 min(tsum)], 'k-');
% xlabel('MN10 Width (um)');
% ylabel('Tau(ns)');
% title('Taus vs MN10 Width');
% legend('Tau Z', 'Tau Out', 'Sum Tau');
% 
% figure('Position', [100, 100, 400, 300]);
% hold on;
% plot(mn10, vo, 'b-');
% plot([10 10], [min(vo) 0], 'k-');
% xlabel('MN10 Width (um)');
% ylabel('Voltage');
% title('Output Common Mode Voltage vs MN10 Width');
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Waveform Plot
% 
% f = fopen('../waveform_export.txt');
% fgetl(f)
% c = t = textscan(f, '%f %f %f');
% fclose(f);
% t = c{1};
% v_iin = c{2};
% v_vout = c{3};
% 
% figure;
% hold on;
% plot(t*1e9, v_vout);
% legend('Vout');
% title('Transient Response');
% xlabel('Time (ns)')
% ylabel('Voltage');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bode Plot

close all
clear all
load('bode.mat');
load('dp.mat');

bw_o = interp1(abs(v_n_vout), f, max(abs(v_n_vout)) * sqrt(2)/2);
bw_x = interp1(abs(v_n_x), f, max(abs(v_n_x)) * sqrt(2)/2);
bw_y = interp1(abs(v_n_y), f, max(abs(v_n_y)) * sqrt(2)/2);
bw_z = interp1(abs(v_n_z), f, max(abs(v_n_z)) * sqrt(2)/2);
bw_i = interp1(abs(v_n_iin), f, max(abs(v_n_iin)) * sqrt(2)/2);

fc = interp1(abs(v_n_vout), f, 1);

fsim = logspace(2, 8, 1000);
sim = dp.h .* dp.total.gain;

figure('Position', [10, 10, 1000, 600]);
h = loglog(f, abs(v_n_iin),'r',...
           f, abs(v_n_x),'b',...
           f, abs(v_n_y),'g',...
           f, abs(v_n_z),'c',...
           f, abs(v_n_vout),'m',...
           fsim, abs(sim), 'k',...
           'Linewidth', 2);

ylim([1, 100000]);
xlim([1e5 1e10]);
legend('Input', 'VX', 'VY', 'VZ', 'Output', 'MATLAB', 'Location','southwest');
xlabel('Frequency');
ylabel('Gain (Ohms)');
title('Design Project Gain Magnitude Plot');

% t = text
s = sprintf('  Low F Gain = %0.0f ohms\n', max(abs(v_n_vout)));
s = strcat('\uparrow', s);
t = text(1000,20000,{s; '    Estimated 30090'});
set(t, 'FontSize', 12);
t = text(1e7,1000,{'Z and Out gain as expected';...
                'Z Actual - 1.440';...
                'Z Design - 1.414';...
                'Out Actual - 0.75';...
                'Out Design - 0.71'});
set(t, 'FontSize', 12);

t = text(5e5,1000,{'X and Y gain as expected';...
                'X Actual - 9.86k';...
                'X Design - 10.0k';...
                'Y Actual - 3.25';...
                'Y Design - 3.0'});
set(t, 'FontSize', 12);              
              
t = text(1e6,100,{'Found gain estimation and power estimation';...
                  'in MATLAB script to be straightforward,';...
                  'but pole frequency and total bandwidth was';...
                  'exceedingly difficult to estimate, especially';...
                  'for the Z and output nodes.'});
set(t, 'FontSize', 12);              
              
s = sprintf(' BW = %0.1fMHz\n', bw_o/1e6);
s = strcat('\leftarrow', s);
t = text(bw_o*1.2,30000*sqrt(2)/2,{s; '    Estimated 50.3MHz'})
set(t, 'FontSize', 12);
s = 'Crossover Frequency = 1.71GHz\rightarrow';
t = text(2e9,2,s,...
   'HorizontalAlignment','right') 
set(t, 'FontSize', 12);
%# capture handle to current figure and axis
hFig = gcf;
hAx1 = gca;

%# create a second transparent axis, as a copy of the first
hAx2 = copyobj(hAx1,hFig);
delete( get(hAx2,'Children') )
set(hAx2, 'Color','none', 'Box','on', ...
    'XGrid','off', 'YGrid','off')

%# show grid-lines of first axis, style them as desired,
%# but hide its tick marks and axis labels
set(hAx1, 'XColor',[0.9 0.9 0.9],...
          'YColor',[0.9 0.9 0.9],...
          'XMinorGrid','on',...
          'YMinorGrid','on',...
          'MinorGridLineStyle','-',...
          'XTickLabel',[], 'YTickLabel',[]);
xlabel(hAx1, ''), ylabel(hAx1, ''), title(hAx1, '')
linkaxes([hAx1 hAx2], 'xy');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Phase Plot

figure('Position', [10, 10, 1000, 600]);
h = semilogx(f, unwrap(angle(-v_n_iin))*180/pi,'r',...
           f, unwrap(angle(-v_n_x))*180/pi,'b',...
           f, unwrap(angle(v_n_y))*180/pi,'g',...
           f, unwrap(angle(-v_n_z))*180/pi,'c',...
           f, unwrap(angle(-v_n_vout))*180/pi,'m',...
           [fc fc], [-500 0], 'k',...
           'Linewidth', 2);

%ylim([, 10]);
legend('Input', 'VX', 'VY', 'VZ', 'Output', 'Crossover Frequency', 'Location','southwest');
xlabel('Frequency');
ylabel('Phase (degrees)');
title('Design Project Phase Plot');
xlim([1e5 1e10]);

s = 'Heres the effect of the cascode bootstrap \rightarrow';
t = text(2e9,-425,{s; 'Happens to line up with Fc'},...
   'HorizontalAlignment','right');
set(t, 'FontSize', 12);

s = 'Miller zero?';
t = text(10e9,-465,s,...
   'HorizontalAlignment','right');
set(t, 'FontSize', 12);
 
s = {'The poles are rather';
     'close to each other';
     'as can be seen from the';
     'phases advancing together';
     };
t = text(5e6,-80,s);
set(t, 'FontSize', 12);

s = {'Estimated Pole Frequencies';
     'Input: 143MHz';
     'X: 370MHz';
     'Y: 520MHz';
     'Z: 83MHz';
     'Output: 97MHz';
     };
t = text(5e6,-180,s);
set(t, 'FontSize', 12);

s = {'Phase at Fc is ~-425deg';
     'If you try negative feedback';
     'on this amplifier, you''re';
     'going to have a bad time.';
     };
t = text(1e7,-350,s);
set(t, 'FontSize', 12);


%# capture handle to current figure and axis
hFig = gcf;
hAx1 = gca;

%# create a second transparent axis, as a copy of the first
hAx2 = copyobj(hAx1,hFig);
delete( get(hAx2,'Children') )
set(hAx2, 'Color','none', 'Box','on', ...
    'XGrid','off', 'YGrid','off')

%# show grid-lines of first axis, style them as desired,
%# but hide its tick marks and axis labels
set(hAx1, 'XColor',[0.9 0.9 0.9],...
          'YColor',[0.9 0.9 0.9],...
          'XMinorGrid','on',...
          'YMinorGrid','on',...
          'MinorGridLineStyle','-',...
          'XTickLabel',[], 'YTickLabel',[]);
xlabel(hAx1, ''), ylabel(hAx1, ''), title(hAx1, '')
linkaxes([hAx1 hAx2], 'xy');