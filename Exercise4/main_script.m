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
#Compute the average number of friends ¯d in network. Compute the average 
#¯f over the average numberof friends that friends have.
#Compare the values ¯d and ¯f. Explain the results
d_u_avg = mean(d_u);
f_u_avg = mean(f_u);