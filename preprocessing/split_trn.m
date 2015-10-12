% split the training links into disjoint chunks
function chunk = split_trn(trn, folds)
for k = 1:folds
    s{k} = k:folds:trn.n;
    chunk{k}.o = trn.o(s{k},:);
    chunk{k}.y = trn.y(s{k},:);
    chunk{k}.n = size(s{k},2);
end
