function p = getParams()
    p.ma = 1;                 % kg
    p.mb = 0.2;               % kg
    p.mc = 0.5;               % kg
    p.lb = .2;                % m
    p.lc = p.lb*2;              % m
    p.Ib = 1/3*p.mb*(p.lb*2)^2;   % kg*m^2
    p.Ic = p.mc*p.lc^2;           % kg*m^2
    p.g = 9.8;                % m/s^2
    p.fa = 0.01;             % N/m/s
    p.fb = 0.01;             % N/rad/s

    p.noise.sensor = [(.001)^2, 0;...
                      0   , (deg2rad(.1))^2];

%     p.noise.process = .0000001*eye(4); 
    p.noise.process = ...
        [(0)^2, 0, 0, 0;...
        0, (.001)^2, 0, 0;...
        0, 0, (0)^2, 0;...
        0, 0, 0, (deg2rad(.1))^2];
  % p.noise.pricess = 
  % [ var(x1),     cov(x1, x2), cov(x1, x3), cov(x1, x4)
  %   cov(x2, x1), var(x2),     cov(x2, x3), cov(x2, x4)
  %   cov(x3, x1), cov(x3, x2), var(x3),     cov(x3, x4)
  %   cov(x4, x1), cov(x4, x2), cov(x4, x3), var(x4)   ]

    p.uRange = [-25, 25];
end