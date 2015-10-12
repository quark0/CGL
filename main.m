%load configurations
run('config.m');
%load courses
[~,X] = libsvmread(opt.course_file);
X = row_l2_normalize(X);
%load prerequisite links
L = load(opt.prereq_file);
%generate positive and "negative" examples for training
trn = generate_trn(L(:,2:-1:1),size(X,1));
%split the data into 3 folds
chunk = split_trn(trn,3);
for i = 1:3
    T{i} = generate_triplets(chunk{i});
end
%variables recoding the performance over test set
map_tes = zeros(3,1);
auc_tes = zeros(3,1);
ndcg_tes = zeros(3,opt.topK);

for k = 1:3
    %get the index for training, validation and test set
    k_trn = k;
    k_val = rem(k,3)+1;
    k_tes = rem(k+1,3)+1;
    disp(['------------------------------ round ' num2str(k) ' -------------------------------'])
    % tune parameters on the validation set
    optimal.map.val = -Inf;
    optimal.auc.val = -Inf;
    optimal.ndcg.val = -Inf;

    for C = opt.Clist
        opt.C = C;
        %training phase
        [F,obj,B(:,:,k)] = opt.algorithm(X,T{k_trn},opt,chunk{k_val});

        %validation phase
        map_val = eval_map(F,chunk{k_val});
        auc_val = eval_auc(F,T{k_val});
        ndcg_val = eval_ndcg(F,chunk{k_val},opt.topK);

        %print the performance in the validation phase
        fprintf('val: map=%.3f auc=%.3f ndcg@[1:%d]=',map_val,auc_val,opt.topK)
        fprintf('%.3f ',ndcg_val);
        fprintf('obj=%e\n',obj);
        if map_val > optimal.map.val
            optimal.map.val = map_val;
            optimal.map.C = opt.C;
            optimal.map.F = F;
        end
        if auc_val > optimal.auc.val
            optimal.auc.val = auc_val;
            optimal.auc.C = opt.C;
            optimal.auc.F = F;
        end
        if mean(ndcg_val) > optimal.ndcg.val
            optimal.ndcg.val = mean(ndcg_val);
            optimal.ndcg.C = opt.C;
            optimal.ndcg.F = F;
        end
    end
    %testing phase
    map_tes(k) = eval_map(optimal.map.F,chunk{k_tes});
    auc_tes(k) = eval_auc(optimal.auc.F,T{k_tes});
    ndcg_tes(k,:) = eval_ndcg(optimal.ndcg.F,chunk{k_tes},opt.topK);
    fprintf('val: map=%.3f auc=%.3f ndcg@[1:%d]=',map_tes(k),auc_tes(k),opt.topK)
    fprintf('%.3f ',ndcg_tes(k,:));
    fprintf('\n');
end
%print the averaged performance in the testing phases
fprintf('\nave: map=%.3f+-%.3f auc=%.3f+-%.3f ndcg@[1:%d]=',...
mean(map_tes),std(map_tes),mean(auc_tes),std(auc_tes),opt.topK);
fprintf('%.3f ',mean(ndcg_tes));
fprintf('\n');

%save the concept graph A
%A = X'*sparse(mean(B,3))*X;
%save(opt.output_file,A);
