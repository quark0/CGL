function [F,obj] = cgl_rank(X,T,opt,val)
%%CGL_RANK concept graph learning with ranking loss

n = size(X,1);

K = full(X*X') + 1e-8*eye(n);
if opt.transductive == true
    [~,neighbors] = sort(K,2,'descend');
    ix = sub2ind([n,n], repmat((1:n)',opt.nn,1), reshape(neighbors(:,1:opt.nn),opt.nn*n,1));

    W = zeros(n,n);
    W(ix) = K(ix);
    K = max(W,W');
    d = diag(1./(sum(K,2)+eps).^0.5);
    K = d*K*d;
    if opt.diffusion
        K = expm(K);
    end
    Regularization_Map = @(F) F-K*F*K;
    Precondition_Map = @(F) F;
else
    inv_K = inv(K);
    Regularization_Map = @(F) inv_K*F*inv_K;
    Precondition_Map = @(F) K*F*K;
end

II = [T(:,1);T(:,1)];
JK = [T(:,2);T(:,3)];
IJ = sub2ind([n,n],T(:,1),T(:,2));
IK = sub2ind([n,n],T(:,1),T(:,3));

% expression of the CGL objective function
Objective = @(F) opt.C*norm(max(0,1-F(IJ)+F(IK)),'fro')^2 + sum(sum(Regularization_Map(F).*F))/2;

F = zeros(n,n);
obj_old = Inf;
obj = Inf;

for r = 1:opt.maxIter
    % compute \delta_{ijk} for each triplet in T
    deltas = max(0,1-F(IJ)+F(IK));
    % compute the gradient
    Gradient = opt.C*sparse(II,JK,[deltas;-deltas],n,n);
    % compute the Hessian (as a linear mapping from its row space to column space)
    Hessian_Map = @(X) opt.C*lambda_multiply(X,T,F) + Regularization_Map(X);
    % compute the Newton direction N using preconditioned conjugate gradient
    [N,res,iter] = matrix_free_pcg(F,Gradient,Hessian_Map,Precondition_Map,10,1e-6);
    % simple backtracking search to determine the step size s
    if opt.backtracking
        s = 1;
        F_0 = F;
        for t = 1:10
            F_t = F_0 + s*(N - F_0);
            obj_t = Objective(F_t);
            if obj_t > obj
                s = s*0.95;
            else
                obj = obj_t;
                F = F_t;
            end
        end
    else
        F = F - N;
    end
    if obj >= obj_old
        break;
    end
    obj_old = obj;
    if ~opt.quiet
        fprintf('it=%d |gradient|=%e obj=%e cg.iter=%d cg.res=%f\n', ...
            r, norm(Gradient(:)), obj, iter, res);
    end
end

