function plotKalman(data)

    %% Evaluate Kalman Filter
    measurements = data.x_measure;
    measurements = [measurements(1,1:end-1); diff(measurements(1,:))/data.inputs.dt;...
        measurements(2,1:end-1); diff(measurements(2,:))/data.inputs.dt];

    truth = data.x_truth;
    estimation = data.x_est;

    measurement_error = abs(measurements - truth(:,1:end-1));
    estimation_error = abs(estimation - truth);
    
    disp('x')
    rms(measurement_error(1,:))
    rms(estimation_error(1,:))
    disp('xd')
    rms(measurement_error(2,:))
    rms(estimation_error(2,:))
    disp('theta')
    rad2deg(rms(measurement_error(3,:)))
    rad2deg(rms(estimation_error(3,:)))
    disp('thetad')
    rad2deg(rms(measurement_error(4,:)))
    rad2deg(rms(estimation_error(4,:)))
    %% get measurement errors
%     measurement_error = (data.x_truth([1,3], :) - data.x_measure);
%     estimation_error = (data.x_truth - data.x_est);
% 
%     bins= 10e-4*(0:0.25:5);
% 
%     figure();
%     histogram(measurement_error(1,:), bins); hold on;
%     histogram(estimation_error(1,:), bins);
%     legend

%     figure();
%     plot(data.t, measurement_error(2,:), 'DisplayName', 'Measurement Error'); hold on;
%     plot(data.t, estimation_error(3,:), 'DisplayName', 'Estimation Error');
%     legend();

%     name = "temp";
%     
%     % Plot truth vs time and est vss time
%     figure('Position',[10 10 500 400])
%     subplot(2,1,1)
%     plot(data.t, data.x_truth(1,:), '-', 'DisplayName','X'); hold on; grid on;
%     plot(data.t, data.x_est(1,:), '.', 'DisplayName','X est');
%     plot(data.t, data.x_measure(1,:), '.', 'DisplayName','X measure');
%     plot(data.t, data.x_truth(2,:), '-', 'DisplayName','dX');
%     plot(data.t, data.x_est(2,:), '.', 'DisplayName','dX est');
%     xlabel('Time (s)')
%     ylabel('X (m), dX (m/s)')
%     title("X, Xd vs Time")
%     legend
% 
%     subplot(2,1,2)
%     plot(data.t, rad2deg(data.x_truth(3,:)), '.', 'DisplayName','Theta'); hold on; grid on;
%     plot(data.t, rad2deg(data.x_truth(4,:)), '.', 'DisplayName','dTheta')
%     xlabel('Time (s)')
%     ylabel('Theta (rad), dTheta (rad/s)')
%     title("Theta, dTheta vs Time")
%     legend
%     sgtitle(name)

end