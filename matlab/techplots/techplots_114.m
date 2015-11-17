addpath('/usr/class/ee214/matlab/hspice_toolbox');
%addpath('HspiceToolbox');
tech_data = loadsig('techplots_114.sw0');
lssig(tech_data)
ngmid = evalsig(tech_data, 'ngm_id');
ngmro = evalsig(tech_data, 'ngmro');
nft = evalsig(tech_data, 'nft');
nidw = evalsig(tech_data, 'nidw');
vth_mn1 = evalsig(tech_data, 'vth_mn1');
vgs = evalsig(tech_data, 'gs');
pgmid = evalsig(tech_data, 'pgm_id');
pgmro = evalsig(tech_data, 'pgmro');
pft = evalsig(tech_data, 'pft');
pidw = evalsig(tech_data, 'pidw');
vth_mp1 = evalsig(tech_data, 'vth_mp1');


save('techplots.mat');
