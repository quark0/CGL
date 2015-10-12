clear;

addpath('preprocessing','algorithm','evaluation','tool');

opt.course_file = 'data/cmu.lsvm';
opt.prereq_file = 'data/cmu.link';

%list of tuning parameters to try
opt.Clist = power(10,[-3:3]);
opt.algorithm = @cgl_rank;
opt.maxIter = 10;
opt.output_file = 'concept_graph.mat';

opt.topK = 3;
opt.quiet = true;
opt.backtracking = true;
