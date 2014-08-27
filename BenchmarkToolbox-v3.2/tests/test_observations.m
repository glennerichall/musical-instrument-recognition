clearvars;
clc;

A = Observation(2);
A.extractionfunction = @(x) [x x;2*x 2*x];
B = Observation(1);
B.extractionfunction = @(x) 2*x;
C = Observation(1);
C.extractionfunction = @(x) 3*x;

o = [A B C];

r = extract(o,1);


A.name = 'TestA';
A.varnames = 'lin';
B.name = 'TestB';
B.varnames = 'lin';
display(A);
[o.varnames]
% TODO complete tests