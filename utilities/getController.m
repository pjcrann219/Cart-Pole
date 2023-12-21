function controller = getController(type, p)
    % Contains controller parameters
    switch type
        case 'lqr1'
            controller.type = 'lqr';
            controller.lqr.K = designLQR(p, [100, 1, 1, 1]);
        case 'lqr2'
            controller.type = 'lqr';
            controller.lqr.K = designLQR(p, [1, 1, 100, 1]);
        case 'pd2'
            controller.type = 'pd2';
            controller.pd2.Pt = 10;
            controller.pd2.Dt = 30;
            controller.pd2.Pu = 65;
            controller.pd2.Du = 45;
        otherwise
            error('Invalid Controller type')
    end
end