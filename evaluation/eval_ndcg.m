% return the ndcg at top @k
function ndcg = eval_ndcg(Y, tes, top)

score = zeros(tes.n,1);
for i = 1:tes.n
    u = tes.o(i,1);
    v = tes.o(i,2);
    score(i) = Y(u,v);
end

% [k-th_score, i_k, j_k, y_k]
st_score = -sortrows(-[score,tes.o,tes.y > 0],1);

ndcg = zeros(top,1);
nq = zeros(top,1);

for i = unique(tes.o(:,1))'

    rl = st_score(st_score(:,2) == i,:);

    % dcg
    dcg = zeros(top,1);
    for k = 1:top
        dcg(k:top) = dcg(k:top) + rl(k,4)/log2(k+1);
    end

    % ideal dcg
    % i.e. place all relavent instances to the top
    idcg = zeros(top,1);
    n_relavent = sum(rl(:,4));
    for k = 1:min(top, n_relavent)
        idcg(k:top) = idcg(k:top) + 1/log2(k+1);
    end

    for k = 1:top
        if idcg(k) ~= 0
            nq(k) = nq(k) + 1;
            ndcg(k) = ndcg(k) + dcg(k)/idcg(k);
        end
    end
end

ndcg = ndcg./nq;
