% generate all possible edges e_ij and their labels y_ij \in {-1,+1}
function trn = generate_trn(L, n)
T = zeros((n-1)*n,2);
k = 1;
for i = 1:n
    for j = 1:n
        if j ~= i
            T(k,:) = [i,j];
            k = k + 1;
        end
    end
end
trn.o = T;
trn.y = 2*ismember(trn.o,L,'rows') - 1;
trn.n = size(trn.o,1);
end
