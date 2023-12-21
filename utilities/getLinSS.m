function [A, B, C, D] = getLinSS(p)
%% Get Linearized State Space Model
M = p.ma + p.mb + p.mc;
a = p.mb*p.lb + p.mc*p.lc;
b = p.mb*p.lc^2 + p.mc*p.lc^2 + p.Ib + p.Ic;
den = a^2 - M*b;

A = zeros(4);
A(1,2) = 1; 
A(2,2) = p.fa*b / den;
A(2,3) = a*b*p.g / den;
A(2,4) = -b*p.fb / den;

A(3,4) = 1;
A(4,2) = -a*p.fa / den;
A(4,3) = -a*M*p.g / den;
A(4,4) = M*p.fa / den;

B = [0;...
    b / den;...
    0;...
    -a / den];

C = [1, 0, 0, 0; ...
    0, 0, 1, 0];

D = 0;

end