function plotEstState(data)

    figure()
    subplot(2,1,1)
    plot(data.t, data.x_truth(1,:), '-r', 'DisplayName','x truth'); hold on;
    plot(data.t, data.x_est(1,:), '.r', 'DisplayName','x est'); hold on;
    plot(data.t, data.x_truth(2,:), '-b', 'DisplayName','xd truth'); hold on;
    plot(data.t, data.x_est(2,:), '.b', 'DisplayName','xd est'); hold on;
    xlabel('Time (s)')
    ylabel('X (m)')
    title('X Estimate')
    legend

    subplot(2,1,2)
    plot(data.t, data.x_truth(3,:), '-r', 'DisplayName','Theta truth'); hold on;
    plot(data.t, data.x_est(3,:), '.r', 'DisplayName','Theta est'); hold on;
    plot(data.t, data.x_truth(4,:), '-b', 'DisplayName','Theta d truth'); hold on;
    plot(data.t, data.x_est(4,:), '.b', 'DisplayName','Theta d est'); hold on;
    xlabel('Time (s)')
    ylabel('Theta (rad)')
    title('Theta Estimate')
    legend

    disp("Estimate: ")
    disp(strjoin(string(rmse(data.x_est, data.x_truth, 2))))

    sgtitle(strjoin(string(rmse(data.x_est, data.x_truth, 2))))

end
