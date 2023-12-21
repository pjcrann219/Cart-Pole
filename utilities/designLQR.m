function K = designLQR(p, diagQ)

% Call getLinSS to get A and B
[A, B, ~, ~] = getLinSS(p);
% MATLAB built in function to compute K
K = lqr(A, B, diag(diagQ), 1);

end