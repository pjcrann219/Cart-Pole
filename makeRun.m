%% Example of how to run simulation
addpath('utilities/');
addpath('plotting/');
addpath('figures/');

close all; clc; clear all;
tf = 10; % Final time (s)
dt = .01; % Time step (s)z
p = getParams(); % Load in model parameters
x0 = [0; 0; 0; 0]; % Initial state [m, m/s, rad, rad/s]
xd = [5; 0; 0; 0]; % Desired state [m, m/s, rad, rad/s]

lqr1 = getController('lqr1', p);       % Load Controller
run = mySim(p, tf, dt, lqr1, x0, xd);  % Run Simi
run = processRunData(run, true);       % Process data

animateRun(run, p, 'Example')   % Make animation
plotStates(run)                 % Make state/U plots

