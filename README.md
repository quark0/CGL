# CGL
The code implements a family of Concept Graph Learning (CGL) algorithms developed in the following papers:
>Hanxiao Liu, Wanli Ma, Yiming Yang, and Jaime Carbonell. "Learning Concept Graphs from Online Educational Data." In Journal of Artificial Intelligence Research 55 (2016): 1059-1090. [[PDF](http://www.cs.cmu.edu/~hanxiaol/publications/liu-jair16.pdf)]

>Yiming Yang, Hanxiao Liu, Jaime Carbonell, and Wanli Ma. "Concept graph learning from educational data." In the Eighth ACM International Conference on Web Search and Data Mining, pp. 159-168. ACM, 2015. [[PDF](http://www.cs.cmu.edu/~hanxiaol/publications/yang-wsdm15.pdf)]

More details about the task and datasets can be found at our [project webpage](http://bonda.lti.cs.cmu.edu/teacher/). The raw data crawled from MIT OpenCourseWare can be found under `data_raw`.

Please cite the above papers if you end up using our code and/or datasets. 

### Demo
Concept graph automatically induced from [MIT OpenCourseWare](http://ocw.mit.edu/):

<img src="http://www.cs.cmu.edu/~hanxiaol/img/cgl.png" width="512">

### Usage
To conduct cross-validation using plain CGL, run
```
matlab -r main
```
Configurations of the program are located at `config.m`. To allow graph transduction, set
```
opt.transductive = false;
```
To carry out sparse CGL, set
```
opt.algorithm = @cgl_rank_sparse;
```

### Author
[Hanxiao Liu](http://www.cs.cmu.edu/~hanxiaol/), Carnegie Mellon University.

