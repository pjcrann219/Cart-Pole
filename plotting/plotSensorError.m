function plotSensorError(data)

    figure()
    subplot(2,1,1)
    title('Truth X - raw X')
    plot(data.t, data.x_truth(1,:) - data.x_raw(1,:), '-o', 'DisplayName','x'); hold on;
    xlabel('Time (s)')
    ylabel('Error X (m)')
    legend

    subplot(2,1,2)
    title('Truth Theta - raw Theta')
    plot(data.t, data.x_truth(3,:) - data.x_raw(3,:), '-o', 'DisplayName','theta'); hold on;
    xlabel('Time (s)')
    ylabel('Error Theta (rad)')
    legend

end