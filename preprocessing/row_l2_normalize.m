function X = row_l2_normalize(X)

n = size(X,1);
d = sqrt(sum(X.^2,2));
row_norm = max(d,1);
X = spdiags(row_norm,0,n,n)\X;

