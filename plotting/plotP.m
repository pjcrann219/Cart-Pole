function plotP(data)
    figure();
    plot(data.t, data.P, '-')
    xlabel('Time (s)');
    ylabel('Covariance Diag')

end