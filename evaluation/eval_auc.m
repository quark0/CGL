% T - triplets in the test set
function auc = eval_auc(Y, T)

n = size(Y,1);

IJ = sub2ind([n,n],T(:,1),T(:,2));
IK = sub2ind([n,n],T(:,1),T(:,3));

auc = sum(Y(IJ) - Y(IK) > 0)/size(T,1);
