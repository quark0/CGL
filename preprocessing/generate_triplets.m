% generate triplets (i,j,k) based on the pairs in chunk
function triplets = generate_triplets(chunk)

triplets = [];
cyp = chunk.o(chunk.y == +1,:);
cyn = chunk.o(chunk.y == -1,:);

for i = unique(chunk.o(:,1))'
    pos_pool = cyp(cyp(:,1) == i,2);
    if isempty(pos_pool)
        continue
    end
    neg_pool = cyn(cyn(:,1) == i,2);
    [a,b] = ndgrid(pos_pool,neg_pool);
    combo = [a(:),b(:)];
    triplets = [triplets; [repmat(i,size(combo,1),1),combo]];
end
