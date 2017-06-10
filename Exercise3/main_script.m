# Prevent Octave from thinking that this
# is a function file:
1;
clear;

function [A] = load_sparse_as_identical(filename)
C = load(filename);
i = C'(1,:);
j = C'(2,:);
sv(1:length(i)) = 1;
dimension = max(max(i),max(j));
A = full(sparse(i,j,sv,dimension,dimension));
A = A + A';
endfunction
B = load_sparse_as_identical("prediction-graph.txt");

[U, Lambda] = eig(B);

d = diag(Lambda);
max_eigen_value = max(d)
min_eigen_value = min(d)