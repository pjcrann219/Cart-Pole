function data = processRunData(data, debug)
    if nargin < 2 || isempty(debug)
        debug = false;
    end
    xdesired = data.inputs.xd;
    error = data.x_truth - xdesired;
    t = data.t;
    % 95% Settling Time

    % Index of points within +- 5% of xd
    inTs = and(data.x_truth(1,:) <= xdesired(1) * 1.05,...
        data.x_truth(1,:) >= xdesired(1) * 0.95);
    idxTs = find(~inTs, 1, 'last') + 1;
    if idxTs > length(t) % Invalid idxTs
        idxTs = -999;
        Ts = -999;
    else % Valid idxTs
        Ts = data.t(idxTs);
    end
    if debug
        figure()
        plot(t(inTs), data.x_truth(1,inTs), 'g.', 'DisplayName','Within Allowed Error'); hold on;
        plot(t(~inTs), data.x_truth(1,~inTs), 'r.', 'DisplayName','Outside Allowed Error')
        title(['x1 vs time. Ts = ', string(Ts)])
        xlabel('Time (s)')
        ylabel('x1 (m)')
        legend;
    end

    data.stats.Ts = Ts;

    % Maximum Overshoot
    
    [overshoot, idxO] = max(error, [], 2);
    data.stats.overshoot = overshoot;

    if debug
        disp('Overshoot = ')
        disp(overshoot)
        figure
        for j = 1:4
            plot(t, data.x_truth(j,:)); hold on;
            plot(t(idxO(j)), data.x_truth(j, idxO(j)), 'o')
        end
        
    end

end