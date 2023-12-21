close all;
% Time info
tf = 15; % Final time (s)
dt = .01; % Time step (s)

% Load parameters
p = getParams();

% initial and final states
x0 = [0; 0; 0; 0]; % Initial state [m, m/s, rad, rad/s]
xd = [5; 0; 0; 0]; % Desired state [m, m/s, rad, rad/s]

do_save = true;

%% LQR1
lqr1 = getController('lqr1', p); % Load controller

lqr1run = mySim(p, tf, dt, lqr1, x0, xd, false); 
lqr1run = processRunData(lqr1run, []);

% animateRun(lqr1run, p, 'LQR 1 Simulation with no Kalmann Filter')
animateRun(lqr1run, p, 'LQR 1 Simulation with no Kalmann Filter', 'gifs\noKalman.gif')

plotStates(lqr1run, "LQR 1 Response with no Kalman Filter", 'noKalman')
saveas(gcf, 'figures\noKalman.png')


