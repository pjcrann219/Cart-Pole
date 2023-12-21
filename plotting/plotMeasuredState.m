function plotMeasuredState(data)

    figure()
    subplot(2,1,1)
    plot(data.t, data.x_truth(1,:), '-r', 'DisplayName','x truth'); hold on;
    plot(data.t, data.x_measure(1,:), '.r', 'DisplayName','x measured'); hold on;
    plot(data.t, data.x_truth(2,:), '-b', 'DisplayName','xd truth'); hold on;
    xlabel('Time (s)')
    ylabel('X (m)')
    title('X Raw')
    legend

    subplot(2,1,2)
    plot(data.t, data.x_truth(3,:), '-r', 'DisplayName','Theta truth'); hold on;
    plot(data.t, data.x_measure(2,:), '.r', 'DisplayName','Theta measured'); hold on;
    plot(data.t, data.x_truth(4,:), '-b', 'DisplayName','Theta d truth'); hold on;
    xlabel('Time (s)')
    ylabel('Theta (rad)')
    title('Theta Raw')
    legend
    disp("Raw: ")
    disp(strjoin(string(rmse(data.x_measure, data.x_truth([1,3], :), 2))))
    sgtitle(strjoin(string(strjoin(string(rmse(data.x_measure, data.x_truth([1,3], :), 2))))))
   
end