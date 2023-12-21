function plotU(data, name)

    if nargin < 2 || isempty(name)
        name = "";
    end

    figure('Position',[10 10 500 300])
    plot(data.t, data.u, '-r', 'DisplayName','U input'); hold on;
    xlabel('Time (s)')
    ylabel('U (N)')
    title([name, ' Input Force U'])
    legend


end