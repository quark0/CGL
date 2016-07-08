%load configurations
run('config.m');

%load course syllabus
[~,X] = libsvmread(opt.course_file);
X = row_l2_normalize(X);
%load prerequisite links
links = load(opt.prereq_file);
%generate positive and negative prerequiste pairs
trn = generate_trn(links(:,2:-1:1),size(X,1));
%split the data into 3-folds
chunk = split_trn(trn,3);

for i = 1:3
    %generate triplets based on pairs
    T{i} = generate_triplets(chunk{i});
end

for k = 1:3
    %indices of training, validation and test set
    k_trn = k;
    k_val = rem(k,3)+1;
    k_tes = rem(k+1,3)+1;

    disp(['----------------------------- round ' num2str(k) ' ------------------------------'])

    best.map.val = -Inf;
    best.auc.val = -Inf;
    best.ndcg.val = -Inf;

    for C = opt.C_pool
        opt.C = C;

        %training phase
        [F,obj] = opt.algorithm(X,T{k_trn},opt,chunk{k_val});

        %validation phase
        map.val = eval_map(F,chunk{k_val});
        auc.val = eval_auc(F,T{k_val});
        ndcg.val = eval_ndcg(F,chunk{k_val},opt.topK);

        fprintf('val: map=%.3f auc=%.3f ndcg@[1:%d]=',map.val,auc.val,opt.topK)
        fprintf('%.3f ',ndcg.val);
        fprintf('obj=%.4e\n',obj);

        if map.val > best.map.val
            best.map.val = map.val;
            best.map.C = opt.C;
            best.map.F = F;
        end
        if auc.val > best.auc.val
            best.auc.val = auc.val;
            best.auc.C = opt.C;
            best.auc.F = F;
        end
        if mean(ndcg.val) > best.ndcg.val
            best.ndcg.val = mean(ndcg.val);
            best.ndcg.C = opt.C;
            best.ndcg.F = F;
        end
    end

    %testing phase
    map.tes(k) = eval_map(best.map.F,chunk{k_tes});
    auc.tes(k) = eval_auc(best.auc.F,T{k_tes});
    ndcg.tes(k,:) = eval_ndcg(best.ndcg.F,chunk{k_tes},opt.topK);
    fprintf('val: map=%.3f auc=%.3f ndcg@[1:%d]=',map.tes(k),auc.tes(k),opt.topK)
    fprintf('%.3f ',ndcg.tes(k,:));
    fprintf('\n');
end

%averaged test-set performance
fprintf('\ntes: map=%.3f+-%.3f auc=%.3f+-%.3f ndcg@[1:%d]=',...
    mean(map.tes),std(map.tes),mean(auc.tes),std(auc.tes),opt.topK);
fprintf('%.3f ',mean(ndcg.tes));
fprintf('\n');

