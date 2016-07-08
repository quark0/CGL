clear;

addpath('preprocessing','algorithm','evaluation','tool');

% cmu, mit, prc, cit
dataset = 'cmu'
opt.course_file = strcat(['data/',dataset,'.lsvm'])
opt.prereq_file = strcat(['data/',dataset,'.link'])

%a list of tuning parameters to try
opt.C_pool = power(10,[-3:7]);
opt.algorithm = @cgl_rank;  % @cgl_rank or @cgl_rank_sparse

% CGL
opt.maxIter = 10;
opt.backtracking = true;

% CGL-trans
opt.transductive = false;
opt.nn = 60;                % node degree of the knn graph
opt.diffusion = false;      % heat diffusion (optional)

% CGL-sparse
opt.sparse.lambda = 10;
opt.sparse.eta = 1e-3;
opt.sparse.maxIter = 200;

opt.topK = 3;
opt.quiet = true;

