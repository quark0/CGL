function [F,obj,B] = cgl_rank(X,T,opt,val)
%CGL_RANK ranking-based concept graph learning
% F(i,j) - predicted prerequisite strength from course i to course j
% obj - objective value
% B - dual variables (see the WSDM paper).
% The concept graph A can be recovered via A = X'*B*X 

n = size(X,1);

II = [T(:,1);T(:,1)];
JK = [T(:,2);T(:,3)];
IJ = sub2ind([n,n],T(:,1),T(:,2));
IK = sub2ind([n,n],T(:,1),T(:,3));

K = full(X*X')+1e-4*eye(n,n);
inv_K = inv(K);

Regularization_Map = @(A) inv_K*A*inv_K;
Precondition_Map = @(A) K*A*K;

% expression of the CGL objective function
Objective = @(A) opt.C*norm(max(0,1-A(IJ)+A(IK)),'fro')^2 + sum(sum(Regularization_Map(A).*A))/2;

F = zeros(n,n);
obj_old = Inf;
obj = Inf;

for r = 1:opt.maxIter
    % compute \delta_{ijk} for each triplet in T
    deltas = max(0,1-F(IJ)+F(IK));
    % compute the gradient
    Gradient = opt.C*sparse(II,JK,[deltas;-deltas],n,n);
    % compute the Hessian (as a linear mapping from its row space to column space)
    Hessian_Map = @(A) opt.C*lambda_multiply(A,T,F) + Regularization_Map(A);
    % compute the Newton direction N using preconditioned conjugate gradient
    [N,res,iter] = matrix_free_pcg(F,Gradient,Hessian_Map,Precondition_Map,20,1e-6);
    % use a simplified backtracking search to determine the step size s
    if opt.backtracking
        s = 1;
        F_0 = F;
        for t = 1:10
            F_t = F_0 + s*(N - F_0);
            obj_t = Objective(F_t);
            if obj_t > obj
                s = s / 2;
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
    % print the debugging information during optimization
    if ~opt.quiet
        fprintf('it=%d |gradient|=%e obj=%e cg.iter=%d cg.res=%f\n', r, norm(Gradient(:)), obj, iter, res);
    end
end

B = inv_K*F*inv_K;
