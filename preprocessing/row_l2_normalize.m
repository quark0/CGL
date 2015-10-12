% note each cell of X must >= 1 !!!
% not a perfect solution for singular cases
function X = row_l2_normalize(X)
n = size(X,1);
d = sqrt(sum(X.*X,2));
row_norm = max(d,1);
X = spdiags(row_norm,0,n,n)\X;
end
