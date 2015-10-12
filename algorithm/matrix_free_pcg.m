% the matrix version of preconditioned conjugate gradient
function [x,res,iter] = matrix_free_pcg(x0,b,map_A,map_invM,maxIter,tol)

inner_prod = @(U,V) sum(sum(U.*V));

x = x0;
r = b - map_A(x);
res0 = norm(r(:));
z = map_invM(r);
p = z;
rz_old = inner_prod(r,z);
for iter = 1:maxIter
    res = norm(r(:))/res0;
    if res < tol
        break;
    end
    Ap = map_A(p);
    alpha = rz_old / inner_prod(p,Ap);
    x = x + alpha*p;
    r = r - alpha*Ap;
    z = map_invM(r);
    rz_new = inner_prod(z,r);
    beta = rz_new / rz_old;
    p = z + beta*p;
    rz_old = rz_new;
end
