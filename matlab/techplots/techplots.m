%addpath('/usr/class/ee214/matlab/hspice_toolbox');
addpath('HspiceToolbox');
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

figure(1);
plot(vgs, vth_mn1);
xlabel('nmos v_g_s');
ylabel('nmos v_t_h');
legend('L=1um', 'L=2um', 'L=3um', 'L=4um', 'L=5um');
savefig('N_vth.fig');

figure(2);
plot(vgs, ngmid);
xlabel('nmos v_g_s');
ylabel('nmos g_m / i_d');
legend('L=1um', 'L=2um', 'L=3um', 'L=4um', 'L=5um');
savefig('N_gm_id.fig');

figure(3);
plot(ngmid, ngmro)
ylabel('nmos g_mr_o');
xlabel('nmos g_m / i_d');
legend('L=1um', 'L=2um', 'L=3um', 'L=4um', 'L=5um');
savefig('N_gmro.fig');

figure(4);
plot(ngmid, nft)
ylabel('nmos f_t');
xlabel('nmos g_m / i_d');
legend('L=1um', 'L=2um', 'L=3um', 'L=4um', 'L=5um');
savefig('N_ft.fig');

figure(5);
plot(ngmid, nidw)
ylabel('nmos i_d / w');
xlabel('nmos g_m / i_d');
legend('L=1um', 'L=2um', 'L=3um', 'L=4um', 'L=5um');
savefig('N_id_w.fig');

figure(10);
plot(vgs, vth_mp1);
xlabel('p_vgs');
ylabel('p_vth');
legend('L=1um', 'L=2um', 'L=3um', 'L=4um', 'L=5um');
savefig('P_vth.fig');

figure(20);
plot(vgs, pgmid);
xlabel('pmos v_g_s');
ylabel('pmos g_m / i_d');
legend('L=1um', 'L=2um', 'L=3um', 'L=4um', 'L=5um');
savefig('P_gm_id.fig');

figure(30);
plot(pgmid, pgmro)
ylabel('pmos g_mr_o');
xlabel('pmos g_m / i_d');
legend('L=1um', 'L=2um', 'L=3um', 'L=4um', 'L=5um');
savefig('P_gmro.fig');

figure(40);
plot(pgmid, pft)
ylabel('pmos f_t');
xlabel('pmos g_m / i_d');
legend('L=1um', 'L=2um', 'L=3um', 'L=4um', 'L=5um');
savefig('P_ft.fig');

figure(50);
plot(pgmid, pidw)
ylabel('pmos i_d / w');
xlabel('pmos g_m / i_d');
legend('L=1um', 'L=2um', 'L=3um', 'L=4um', 'L=5um');
savefig('P_id_w.fig');