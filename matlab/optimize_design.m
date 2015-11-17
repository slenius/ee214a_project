clear all
close all

% f = 'evaluate_candidate(x, false)';
% 
% vlb = [0.15 2  2  2  2  1000  1000 0];
% vub = [1.25 256 256 256 256 200000 200000 25];
% bits = [32  32 32 32 32 32    32 32];
% options = foptions([1]);
% options(13) = 0.03;
% options(11) = 5x0;
% options(14) = 1000;
% 
% [x,stats,options,bf,fg,lg] = genetic(f,[],options,vlb,vub,bits);

% f = 'sizeall(x, false)';
% 
% vlb = [0.15 2   2   2   2   2   2   2   2   2   2   1000   1000   1000   1000];
% vub = [1.25 256 256 256 256 256 256 256 256 256 256 200000 200000 200000 200000];
% bits = [32  32  32  32  32  32  32  32  32  32  32  32     32     32     32];
% options = foptions([1]);
% options(13) = 0.03;
% options(11) = 1000;
% options(14) = 1000;
% 
% x0 = [.75 16 16 32 8 8 4 4 4 32 32 15000 15000 15000 15000]; 
% 
% [x,stats,options,bf,fg,lg] = genetic(f,x0,options,vlb,vub,bits);



dp = design_project(load_defaults(0.75, 16, 4, 4, 32, 20000, 22500, 1), true, true);
