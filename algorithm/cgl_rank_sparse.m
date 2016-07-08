function [F,obj,A] = cgl_rank_sparse(X,T,opt,val)
%%CGL_RANK sparse concept graph learning with ranking loss

[n,p] = size(X);
A = sparse(p,p);
B = sparse(p,p);
Q = sparse(p,p);

II = [T(:,1);T(:,1)];
JK = [T(:,2);T(:,3)];
IJ = sub2ind([n,n],T(:,1),T(:,2));
IK = sub2ind([n,n],T(:,1),T(:,3));

active = 0;

%accelerated proximal gradient descent
for r = 1:opt.sparse.maxIter
    F = full(X*A*X');
    deltas = max(0,1-F(IJ)+F(IK));
    obj = sum(deltas.^2) + opt.sparse.lambda*sum(sum(abs(A)));
    fprintf('it=%d, obj=%f, nnz=%d\n', r, obj, active);
    nabla_g = -2*X'*sparse(II,JK,[deltas;-deltas],n,n)*X;
    tmp = B - opt.sparse.eta*nabla_g;
    A = sign(tmp).*bsxfun(@max,0,abs(tmp)-opt.sparse.eta*opt.sparse.lambda*(tmp~=0));
    B = ((2*r+1)*A - (r-1)*Q)/(r+2);    % Nesterov's update
    Q = A;
    active = nnz(A);
end

