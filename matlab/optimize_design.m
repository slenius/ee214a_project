clear all
close all

% vov = linspace(0.2, 1.25, 10);
% size = linspace(2, 20, 10);
% r = linspace(5000, 60000, 10);
% 
% %vov = 1.5;
% %size = 8;
% %r = 15000;
% 
% P1 = vov;
% P2 = size;
% P3 = size;
% P4 = size;
% P5 = size;
% P6 = r;
% P7 = r;
% 
% 
% f = 'evaluate_candidate(x, false)';
% 
% vlb = [0.15 2  2  2  2  1000  1000];
% vub = [1.25 256 256 256 256 200000 200000];
% bits = [32  32 32 32 32 32    32];
% options = foptions([1]);
% options(13) = 0.03;
% options(11) = 500;
% options(14) = 1000;
% 
% [x,stats,options,bf,fg,lg] = genetic(f,[],options,vlb,vub,bits, P1, P2, P3, P4, P5, P6, P7);

dp = design_project(load_defaults(0.75, 16, 4, 4, 32, 20000, 22500), true, true);
