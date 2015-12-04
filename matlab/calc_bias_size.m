clear all
close all

kn = 50e-6;
wl = 1;
vov = 0.7;
m = 2;

iref = 1/2 * kn * wl * vov^2

% iref = vov * (1-sqrt(m)) / r2
r2 = vov * (1-1/sqrt(m)) / iref