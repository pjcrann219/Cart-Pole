function plotPredState(data)

    figure()
    subplot(2,1,1)
    plot(data.t, data.x_truth(1,:), '-r', 'DisplayName','x truth'); hold on;
    plot(data.t, data.x_predict(1,:), '.r', 'DisplayName','x pred'); hold on;
    plot(data.t, data.x_truth(2,:), '-b', 'DisplayName','xd truth'); hold on;
    plot(data.t, data.x_predict(2,:), '.b', 'DisplayName','xd pred'); hold on;
    xlabel('Time (s)')
    ylabel('X (m)')
    title('X Prediction')
    legend

    subplot(2,1,2)
    plot(data.t, data.x_truth(3,:), '-r', 'DisplayName','Theta truth'); hold on;
    plot(data.t, data.x_predict(3,:), '.r', 'DisplayName','Theta pred'); hold on;
    plot(data.t, data.x_truth(4,:), '-b', 'DisplayName','Theta d truth'); hold on;
    plot(data.t, data.x_predict(4,:), '.b', 'DisplayName','Theta d pred'); hold on;
    xlabel('Time (s)')
    ylabel('Theta (rad)')
    title('Theta Prediction')
    legend

    sgtitle(strjoin(string(rmse(data.x_predict, data.x_truth, 2))))
    disp("Prediction: ")
    disp(strjoin(string(rmse(data.x_predict, data.x_truth, 2))))
end
