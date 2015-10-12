function map = eval_map(Y, tes)

score = zeros(tes.n,1);
for i = 1:tes.n
    u = tes.o(i,1);
    v = tes.o(i,2);
    score(i) = Y(u,v);
end

% [k-th_score, i_k, j_k, y_k]
st_score = -sortrows(-[score,tes.o,tes.y],1);

Q = 0; % # query
sap = 0; % sum of ap across queries

for i = unique(tes.o(:,1))'
    rl = st_score(st_score(:,2) == i,:);
    np = 0;
    sp = 0;
    for k = 1:size(rl,1)
        if rl(k,4) == 1
            np = np + 1;
            sp = sp + np/k;
        end
    end
    if np > 0
        Q = Q + 1;
        ap = sp/np;
        sap = sap + ap;
    end
end

map = sap/Q;

end
