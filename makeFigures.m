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

% %% LQR1
% lqr1 = getController('lqr1', p); % Load controller
% 
% lqr1run = mySim(p, tf, dt, lqr1, x0, xd); 
% lqr1run = processRunData(lqr1run, []);
% 
% animateRun(lqr1run, p, 'LQR 1 Simulation', 'gifs\lqr1.gif')

% plotStates(lqr1run, "LQR 1 Response", 'lqr1')
% if do_save
%     saveas(gcf, 'figures\lqr1.png')
% end

%% Kalman Filter

%% LQR2
% lqr2 = getController('lqr2', p); % Load controller
% 
% lqr2run = mySim(p, tf, dt, lqr2, x0, xd); 
% lqr2run = processRunData(lqr2run, []);
% 
% animateRun(lqr2run, p, 'LQR 2 Simulation', 'gifs\lqr2.gif')

% plotStates(lqr2run, "LQR 2 Response", 'lqr2')
% if do_save
%     saveas(gcf, 'figures\lqr2.png')
% end

%% PD2
pd2 = getController('pd2', p); % Load controller
pd2run = mySim(p, tf, dt, pd2, x0, xd); 
pd2run = processRunData(pd2run, []);

animateRun(pd2run, p, '2 Step PD Simulation', 'gifs\pd2.gif')

% plotStates(pd2run, "2 Stage PD Response", 'pd2')
% if do_save
%     saveas(gcf, 'figures\pd2run.png')
% end
