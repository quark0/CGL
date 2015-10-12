% multiply L''(F) with vec(A),
% where L''(F) is the 2nd order derivative of squared hinge loss
function V = lambda_multiply(A,T,F)

V = zeros(size(F));
for t = 1:size(T,1)
    i = T(t,1);
    j = T(t,2);
    k = T(t,3);
    if F(i,j) - F(i,k) < 1
        delta = A(i,j) - A(i,k);
        V(i,j) = V(i,j) + delta;
        V(i,k) = V(i,k) - delta;
    end
end
