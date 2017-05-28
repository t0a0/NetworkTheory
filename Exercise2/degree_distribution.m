function [C] = degree_distribution(A)
[d] = compute_degrees(A);
C = hist(d, 1:max(d));
endfunction