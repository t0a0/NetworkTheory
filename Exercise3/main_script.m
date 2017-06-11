# Prevent Octave from thinking that this
# is a function file:
1;
clear;

function [A] = load_sparse(filename,range)

if(size(range)(1) == 0)
  E = load(filename);
else
  E = dlmread(filename,' ',range);
endif
n = max(max(E));
A = sparse(E(:,1), E(:,2), 1, n, n);
A = A + A';
endfunction

empty_range = [];
B = load_sparse("prediction-graph.txt",empty_range);

[U, Lambda] = eig(B);

max_eigen_value = max(Lambda);
min_eigen_value = min(Lambda);

fb = "facebook-wosn-links/out.facebook-wosn-links";

C = load_sparse(fb,[2, 0, 817037, 1]);
x= eigs(C, 10);
vec_eigs = x/max(x);

function [dom, vec] = power_iter(A) 
dim = size(A)(1);
vec = ones(dim,1);
dom = 0;
threshold = 10;
do
  vec_old = vec;
  vec = A*vec;
  dom = max(vec);
  vec = vec/dom;
until (norm(vec-vec_old) < threshold && abs(vec - vec_old)<threshold)
endfunction

[dom,vec] = power_iter(C);

vec_power_iter = sort(vec, "descend")(1:10);
diff = norm(vec_power_iter - vec_eigs);

