# Prevent Octave from thinking that this
# is a function file:
1;
clear;

fb = "facebook-wosn-links/out.facebook-wosn-links";

function [A] = load_sparse(filename, m, n)
  l = load(filename);
  A = sparse(l(:,1:2)(:), fliplr(l(:,1:2))(:), 1, m, n);
end

FB = load_sparse(fb,63731,63731);
#For each user u in the network, compute the number of friends d(u).
function [degrees] = compute_degrees(A)
degrees = sum(A');
endfunction


d_u = compute_degrees(FB);

#For each user u in the network, compute the average number of friends the friends of u have. Call this
#value f(u).


FOF = FB * FB;
total_fof = sum(FOF);

f_u = total_fof./d_u;

#Compare values d and f for all users. For how many users is d(u) < f(u)? 
#For how many users is d(u) = f(u)? For how many users is d(u) > f(u). 
#Explain the results.

tf = f_u-d_u>0;
du_lower = nnz(tf); 
tf = f_u-d_u==0;
du_equal = nnz(tf);
tf = f_u-d_u<0;
du_greater = nnz(tf);
# EXPLANATION: So, the number of d(u) lower than f(u) is large, because most people
# have les friends then their friends. This is probably because the popular people
# impact the growth of the average number of friends of friends.  

#Compute the average number of friends ¯d in network. Compute the average 
#¯f over the average numberof friends that friends have.
#Compare the values ¯d and ¯f. Explain the results
d_u_avg = mean(d_u);
f_u_avg = mean(f_u);

# task2

#Compute the friend-of-a-friend link prediction matrix in two different ways:
function [A] = load_sparse_as_identical(filename)
C = load(filename);
i = C'(1,:);
j = C'(2,:);
sv(1:length(i)) = 1;
dimension = max(max(i),max(j));
A = full(sparse(i,j,sv,dimension,dimension));
A = A + A';
endfunction

A = load_sparse_as_identical('net.txt');

#Using the square of the adjacency matrix
fof_A = A*A;
#Using the square of the eigenvalues in the eigenvalue decomposition A = UΛUT
[u, lambda] = eigs(A,16);
eig_sqr = u * u;

# Are both resulting matrices identical? Why?

#How many common friends do the users 7 and 10 have? How many common friends do
# the users 7 and 15 have?

function [cn] = common_neighbors(A,n1,n2);
y = A(:,n1) + A(:,n2);
cn = sum(y == 2);
endfunction

n_7_15 = common_neighbors(A,7,15);
#For user number 7, compute friend recommendations based on the friend-of-a-friend recommender. The
#friend recommendations should be a list of other users along with their link prediction scores. The list
#should be sorted by decreasing link prediction score. The list should not contain user 7 himself and his
#neighbors. Which user is at the top of this recommendation list?
function [scores] = link_prediction(A,n); 
k = A*A;
k = k(:,n);
[s,i] = sortrows(k,1);
scores = flipud([s,i]);
TF1 = scores(:,2)==n;
scores(TF1,:) = [];
endfunction
recomendations = link_prediction(A,7);
