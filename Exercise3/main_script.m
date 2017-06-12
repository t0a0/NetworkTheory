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

function [A] = load_sparse_directed(filename)
  E = load(filename);
  n = max(max(E));
  A = sparse(E(:,1), E(:,2), 1, n, n);
endfunction 

function [degrees] = compute_degrees(A)
degrees = sum(A');
endfunction

empty_range = [];
B = load_sparse("prediction-graph.txt",empty_range);

[U, Lambda] = eig(B);
# min and max eigen values 
max_eigen_value = max(diag(Lambda));
min_eigen_value = min(diag(Lambda));
# Zero is not an eigen value of our matrix

fb = "facebook-wosn-links/out.facebook-wosn-links";

C = load_sparse(fb,[2, 0, 817037, 1]);
[x, l]= eigs(C);
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
until (norm(vec-vec_old) < threshold)
endfunction

[dom,vec] = power_iter(C);

vec_power_iter = vec;
# difference between the 2 vecctors
diff = norm(vec_power_iter - vec_eigs);

function [ids10, degrees10] = top_10_user_by_eigs(eig_vals,graph)
  M = eig_vals;
  d = compute_degrees(graph);
  for i=1:10
    [col, row] = max(max(M,[],2));
    ids10(i) = row;
    M([row],:) = [];
    degrees10(i) = d(1,row);
  endfor
endfunction

#Which are the 10 users with the highest eigenvector centrality? 
[top10_id_eigs, degrees10] = top_10_user_by_eigs(vec_eigs,C);

function [ids10] = top_10_users_by_degrees(graph)
 M = compute_degrees(graph);
 for i=1:10
  [row, col] = max(max(M,[],1));
  ids10(i) = col;
  M(:,[col]) = [];
 endfor
endfunction

#What are the 10 users with highest degree in the network?
top10_id_degree = top_10_users_by_degrees(C);

#Do they correspond to the 10 users with highest eigenvector centrality? Why? 
#NO. Because they are not the most connected, but they are close to important nodes