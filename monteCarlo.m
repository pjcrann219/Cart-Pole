clear all;

% Time info
tf = 15; % Final time (s)
dt = .01; % Time step (s)

% Load parameters
p = getParams();

% initial and final states
x0 = [0; 0; 0; 0]; % Initial state [m, m/s, rad, rad/s]
xd = [5; 0; 0; 0]; % Desired state [m, m/s, rad, rad/s]

% number of runs per controller
n_runs = 100;

%% LQR1
lqr1 = getController('lqr1', p); % Load controller

lqr1_batch_stats.Ts = [];        % init Ts
lqr1_batch_stats.overshoot = []; % init overshoot

% Run sims
for i=1:n_runs
    this_run = mySim(p, tf, dt, lqr1, x0, xd); 
    this_run = processRunData(this_run, []);
    lqr1_batch(i) = this_run;
    lqr1_batch_stats.Ts(i) = this_run.stats.Ts;
    lqr1_batch_stats.overshoot(i,:) = this_run.stats.overshoot;
end

%% LQR2
lqr2 = getController('lqr2', p);

lqr2_batch_stats.Ts = [];        % init Ts
lqr2_batch_stats.overshoot = []; % init overshoot

% Run sims
for i=1:n_runs
    this_run = mySim(p, tf, dt, lqr2, x0, xd); 
    this_run = processRunData(this_run, []);
    lqr2_batch(i) = this_run;
    lqr2_batch_stats.Ts(i) = this_run.stats.Ts;
    lqr2_batch_stats.overshoot(i,:) = this_run.stats.overshoot;
end
%% PD2
pd2 = getController('pd2', p);

pd2_batch_stats.Ts = [];        % init Ts
pd2_batch_stats.overshoot = []; % init overshoot

% Run sims
for i=1:n_runs
    this_run = mySim(p, tf, dt, pd2, x0, xd); 
    this_run = processRunData(this_run, []);
    pd2_batch(i) = this_run;
    pd2_batch_stats.Ts(i) = this_run.stats.Ts;
    pd2_batch_stats.overshoot(i,:) = this_run.stats.overshoot;
end

%% Compile runset stats
controllers = ["lqr1"; "lqr2"; "pd2"];

validlqr1 = (lqr1_batch_stats.Ts ~= -999);
validlqr2 = (lqr2_batch_stats.Ts ~= -999);
validpd2 = (pd2_batch_stats.Ts ~= -999);

Ts = [mean(lqr1_batch_stats.Ts(validlqr1));...
    mean(lqr2_batch_stats.Ts(validlqr2));...
    mean(pd2_batch_stats.Ts(validpd2))];

percent_success = 100* [sum(validlqr1)/n_runs;...
    sum(validlqr2)/n_runs;...
    sum(validpd2)/n_runs];

x_Overshoot = [mean(lqr1_batch_stats.overshoot(validlqr1,1));...
    mean(lqr2_batch_stats.overshoot(validlqr2,1));...
    mean(pd2_batch_stats.overshoot(validpd2,1))];

xd_Overshoot = [mean(lqr1_batch_stats.overshoot(validlqr1,2));...
    mean(lqr2_batch_stats.overshoot(validlqr2,2));...
    mean(pd2_batch_stats.overshoot(validpd2,2))];

theta_Overshoot = [mean(lqr1_batch_stats.overshoot(validlqr1,3));...
    mean(lqr2_batch_stats.overshoot(validlqr2,3));...
    mean(pd2_batch_stats.overshoot(validpd2,3))];
theta_Overshoot = rad2deg(theta_Overshoot);

thetaD_Overshoot = [mean(lqr1_batch_stats.overshoot(validlqr1,4));...
    mean(lqr2_batch_stats.overshoot(validlqr2,4));...
    mean(pd2_batch_stats.overshoot(validpd2,4))];
thetaD_Overshoot = rad2deg(thetaD_Overshoot);

results = table(controllers, percent_success, Ts, x_Overshoot, xd_Overshoot, theta_Overshoot, thetaD_Overshoot);
results.Properties.VariableNames = {'Controller Type', 'Percent Success', '5% Settling Time (s)', 'x overshoot (m)'...
    'Maximum x D (m/s)', 'Maximum Theta (deg)', 'Maximum Theta D (deg/s)'};
results
