# Prevent Octave from thinking that this
# is a function file:
1;
clear;

% load_sparse.m
% compute_statistics.m
% compute_degrees.m
% degree_distribution.m

[A] = load_sparse ("out.loc-gowalla_edges");

[size volume] = compute_statistics(A);
[C] = degree_distribution(A);
degree = compute_degrees(A);
loglog(1:max(degree), C, '.');
ylabel('Frequency');
xlabel('Degree(d)');
title('Degree distributions')

[P] = cumulative_degree_distribution(A);
stairs(1:max(degree), P);
set(gca, 'XScale', 'log', 'YScale', 'log');
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on');
axis tight;

G = gini(A);

