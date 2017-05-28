function [G] = gini(A)
[v e] = compute_statistics(A)
degree = compute_degrees(A);
d_sorted = sort(degree);
index = 1:1:v;
up = [d_sorted; index];
sum_u = sum(prod(up));
sum_d = sum(sum(degree));
G = 2*sum_u/(v*sum_d) - ((v+1)/v);
endfunction