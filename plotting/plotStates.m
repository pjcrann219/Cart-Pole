function plotStates(data, name, save)
    if nargin < 2 || isempty(name)
        name = "";
    end
% Plots states
    figure('Position',[10 10 500 200])
    plot(data.t, data.x_truth(1,:), '.', 'DisplayName','X'); hold on; grid on;
    plot(data.t, data.x_truth(2,:), '.', 'DisplayName','dX')
    xlabel('Time (s)')
    ylabel('X (m), dX (m/s)')
    title(strjoin([name, " X, Xd vs Time"]))
    legend
    
    if nargin >= 3
        saveas(gcf, ['figures\', save, '-X.png'])
    end

    figure('Position',[10 10 500 200])
    plot(data.t, rad2deg(data.x_truth(3,:)), '.', 'DisplayName','Theta'); hold on; grid on;
    plot(data.t, rad2deg(data.x_truth(4,:)), '.', 'DisplayName','dTheta')
    xlabel('Time (s)')
    ylabel('Theta (deg), dTheta (deg/s)')
    title(strjoin([name, " Theta, dTheta vs Time"]))
    legend

    if nargin >= 3
        saveas(gcf, ['figures\', save, '-Theta.png'])
    end
    figure('Position',[10 10 500 200])
    plot(data.t, data.u, '-r', 'DisplayName','U input'); hold on; grid on;
    xlabel('Time (s)')
    ylabel('U (N)')
    title(strjoin([name, ' Input Force U']))
    legend

    if nargin >= 3
        saveas(gcf, ['figures\', save, '-U.png'])
    end
end