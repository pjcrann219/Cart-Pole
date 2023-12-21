function data = mySim(p, tf, dt, controller, x0, xd, useKalman)

    if nargin < 7
        useKalman = true;
    end

    % Run info
    data.inputs.p = p;
    data.inputs.tf = tf;
    data.inputs.dt = dt;
    data.inputs.controller = controller;
    data.inputs.x0 = x0;
    data.inputs.xd = xd;
    data.inputs.useKalman = useKalman;

    t = 0:dt:tf; % Time array   
    % To save off data
    data.x_truth = nan([4, length(t)]);
    data.t = t;
    data.u = nan([1, length(t)]);

    % Init
    x_truth = x0;
    u_old = 0;
    x_est = x_truth;

    %Kalman terms
    C = [1, 0, 0, 0;
         0, 0, 1, 0];
    P = ones(4);

    % Iterate through t
    for k = 1:length(t)

        % (1) Compute x_{truth, k} from x_{truth, k-1} and u_{k-1}: Updates
        % x_truth (with noise)
        x_truth = stateTransition(x_truth, u_old, p, dt, true);

        % (2) Measure x_{truth, k}: gets raw sensor measurement
        x_measure = measureState(x_truth, p , C);
        
        if useKalman
            [x_est, P, pred] = KalmanFilter(x_est, P, u_old, x_measure, p, dt);
        else
            x_est([2,4]) = (x_est([1,3]) - x_measure) / dt;
            x_est([1,3]) = x_measure;
        end
        % (3) Compute U_t given control law and estimated/measured x_t
        switch controller.type
            case 'lqr'
                u = inputLQR(x_est, xd, controller.lqr.K);
            case 'pd2'
                u = inputPD2(x_est, xd, controller.pd2);
        end

        % Cap U between Umin and Umax
        if u < p.uRange(1)
            u = p.uRange(1);
        elseif u > p.uRange(2)
            u = p.uRange(2);
        end
        
        % Save old estimate and raw 
        x_est_old = x_est;
        x_measure_old = x_measure;
        u_old = u;

        % % Update P
%         P=(eye(4) - K*C)*P*(eye(4) - K*C)*dt + K*R;

        % Calculate work done at this timestep
        w = u*x_truth(2)*dt; % N* m/s * s = N*m = Jouls

        % Save off data from timestep
        data.xd(:,k) = xd;
        data.x_est(:,k) = x_est;
%         data.pred(:,k) = pred;
        data.x_measure(:,k) = x_measure;
%         data.x_predict(:,k) = x_predict;
        data.x_truth(:,k) = x_truth;
        data.u(k) = u;
        data.w(k) = w;
%         data.P(k, :) = P(logical(eye(4)));

    end

end

function x_measure = measureState(x_truth, p , C)
    x_measure = C*x_truth + sqrt(p.noise.sensor)*randn([2,1]);
end

function u = inputPD2(x_est, xd, pd2)
    thetaD = pd2.Pt*(xd(1)-x_est(1)) - pd2.Dt*(x_est(2));
    if thetaD < deg2rad(-3); thetaD = deg2rad(-3);
    elseif thetaD > deg2rad(3); thetaD = deg2rad(3); end
    u = -pd2.Pu*(thetaD - x_est(3)) + pd2.Du*x_est(4);
end

function u = inputLQR(x, xd, K)
    u = K*(x-xd);
end

function [x_est, P, pred] = KalmanFilter(x_est_old, P, u_old, z, p, dt)
% est = estimated past state
% P = estimation covariance matrix
% u = latest input
% z = measurement

    M = p.ma + p.mb + p.mc;
    a = p.mb*p.lb + p.mc*p.lc;
    b = p.mb*p.lb^2 + p.mc*p.lc^2 + p.Ib + p.Ic;
    tmp = (a^2 - M*b);

    A = [1, dt, 0, 0;...
        0, 1 - p.fa*b*dt/tmp, -a*b*p.g*dt/tmp, b*p.fb*dt/tmp;...
        0, 0, 1, dt;...
        0, a*p.fa*dt/tmp, a*M*p.g*dt/tmp, 1-p.fb*M*dt/tmp];

    B = [0;...
        b*dt/tmp;...
        0;...
        -a*dt/tmp];

    C = [1, 0, 0, 0;...
        0, 0, 1, 0];

    R = p.noise.process;
    Q = p.noise.sensor;

    A = [1, dt, 0, 0;...
        0, 1, 0, 0;...
        0, 0, 1, dt;...
        0, 0, 0, 1];
% 
%     B = [.5*dt^2;...
%         dt;...
%         .5*dt^2;...
%         dt];

    % Priori estimates
    pred = stateTransition(x_est_old, u_old, p, dt, false);
    P = A*P*A.'+ R;
    K = P*transpose(C)/(C*P*C.' + Q);
    x_est = pred + 10*K*(z - C*pred);
    P = (eye(4) - K * C) * P;

end

function x1 = predictState(x, u, p, dt)

    % Compute temp variables for quicker/easier computation
    M = p.ma + p.mb + p.mc;
    a = p.mb*p.lb + p.mc*p.lc;
    b = p.mb*p.lb^2 + p.mc*p.lc^2 + p.Ib + p.Ic;

    phi1 = (u - p.fa*x(2) + a*x(4)^2*sin(x(3))) / M;
    phi2 = (-p.fb*x(4) + a*x(2)*x(4)*sin(x(3)) + a*p.g*sin(x(3)))/b;
    phi3 = 1-(a^2*cos(x(3))^2)/(b*M);

    % Compute xdd and thetadd given current state
    xdd = (phi1 - phi2*b*cos(x(3))/M) / phi3;
    thetadd = (phi2 - phi1*a*cos(x(3))/b)/phi3;

    % Iterate states
    x1 = [x(1) + x(2)*dt;...
        x(2) + xdd*dt;...
        x(3) + x(4)*dt;...
        x(4) + thetadd*dt];

end

function x1 = stateTransition(x, u, p, dt, useNoise)
    if useNoise % Default to noise on
        noise = sqrt(p.noise.process) * randn([4, 1]);
    else
        noise = zeros(4,1);
    end

    % Compute temp variables for quicker/easier computation
    M = p.ma + p.mb + p.mc;
    a = p.mb*p.lb + p.mc*p.lc;
    b = p.mb*p.lb^2 + p.mc*p.lc^2 + p.Ib + p.Ic;

    phi1 = (u - p.fa*x(2) + a*x(4)^2*sin(x(3))) / M;
    phi2 = (-p.fb*x(4) + a*x(2)*x(4)*sin(x(3)) + a*p.g*sin(x(3)))/b;
    phi3 = 1-(a^2*cos(x(3))^2)/(b*M);

    % Compute xdd and thetadd given current state
    xdd = (phi1 - phi2*b*cos(x(3))/M) / phi3;
    thetadd = (phi2 - phi1*a*cos(x(3))/b)/phi3;
    % xd vector
    xd = [x(2);...
        xdd;...
        x(4);...
        thetadd];
    
    % Iterate states
    % x1 = [x(1) + x(2)*dt;...
    %     x(2) + xdd*dt;...
    %     x(3) + x(4)*dt;...
    %     x(4) + thetadd*dt];
    % Zero mean process noise with variance = process noise and std = sqrt(process noise)

    
    % Iterate State
    x1 = x + xd*dt + noise;

end
