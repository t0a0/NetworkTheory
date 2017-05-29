function [size volume] = compute_statistics(A)
size = (size(A))(1,1);
volume = sum(sum(A))/2;
endfunction
