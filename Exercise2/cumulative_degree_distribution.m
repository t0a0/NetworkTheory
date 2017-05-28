function [P] = cumulative_degree_distribution(A)
[d] = compute_degrees(A);
Freq = hist(d, 1:max(d));
Freq_qum = flip(cumsum(flip(Freq)));
P = Freq_qum/max(Freq_qum)
endfunction