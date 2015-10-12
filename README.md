# CGL
Learning the Concept Graph from Educational Data

## Description
An implementation of the CGR.Rank algorithm described in
>Yang, Yiming, Hanxiao Liu, Jaime Carbonell, and Wanli Ma. "Concept Graph Learning from Educational Data." In Proceedings of the Eighth ACM International Conference on Web Search and Data Mining, pp. 159-168. ACM, 2015.

The optimization is carried out based on an inexact Newton's method,
where the preconditioned conjugate gradient method is used for approximately computing the Newton direction.

For more details, please refer to the [NSF project website](http://bonda.lti.cs.cmu.edu/teacher/)

## Usage
The program reads its configurations in `config.m`. To conduct 3-fold cross-validation, run
```
./main
```

## Author
Hanxiao Liu, Carnegie Mellon University
