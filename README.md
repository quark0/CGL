# CGL
Learning the Concept Graph from Educational Data

## Description
An implementation of the CGL.Rank algorithm described in
>Yang, Yiming, Hanxiao Liu, Jaime Carbonell, and Wanli Ma. "Concept Graph Learning from Educational Data." In Proceedings of the Eighth ACM International Conference on Web Search and Data Mining, pp. 159-168. ACM, 2015.

Optimization is carried out based on an inexact Newton's method,
where the preconditioned conjugate gradient method is used to approximate the Newton direction.

For more details, please refer to the [NSF project website](http://bonda.lti.cs.cmu.edu/teacher/)

## Usage
To conduct 3-fold cross-validation, simply run
```
./main
```
The program loads its configurations from `config.m`.

## Author
Hanxiao Liu, Carnegie Mellon University
