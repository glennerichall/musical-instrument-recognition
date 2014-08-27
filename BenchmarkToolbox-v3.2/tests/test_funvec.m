clc;
clearvars;

% test, return non empty value to empty output
f1 = @(x)x;
fc = funvec(f1);
fc(1);

% test, check classes
f1 = @(x)x;
fc = funvec(f1);
assert(isa(fc,'function_handle'));
assert(isa(fc,'funvec'));

% test, check singleton chain
f = @(x)x;
fc = funvec(f);
assert(fc(1)==1);

% test, two chained simple functions
f1 = @(x)x;
f2 = @(x)2*x;
fc = funvec(f1,f2);
[a,b] = fc(1);
assert(a==1 && b==2);

% test, two chained simple functions
f1 = @(x,y)x+y;
f2 = @(x)2*x;
fc = funvec({2},f1,f2);
[a,b] = fc(1);
assert(a==3 && b==2);

% test, func2str
f1 = @(x,y,z)x+y*z;
f2 = @(x,y)x+y;
fc = funvec({3,4},f1,{2},f2);
a = func2str(fc);
assert(strcmp(a,'funvec({[3][4]},@(x,y,z)x+y*z,[1],{[2]},@(x,y)x+y,[1])'));


