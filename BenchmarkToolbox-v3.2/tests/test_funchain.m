clc;
clearvars;

% test, return non empty value to empty output
f1 = @(x)x;
fc = funchain(f1);
fc(1);

% test, check classes
f1 = @(x)x;
fc = funchain(f1);
assert(isa(fc,'function_handle'));
assert(isa(fc,'funchain'));

% test, check singleton chain
f = @(x)x;
fc = funchain(f);
assert(fc(1)==1);

% test, two chained simple functions
f = @(x)x;
fc = funchain(f,f);
assert(fc(1)==1);

% test, another chained simple functions
f1 = @(x)x;
f2 = @(x)2*x;
fc = funchain(f1,f2);
assert(fc(1)==2);

% test, long chain
m=100;
f = arrayfun(@(n) @(x)x+n,1:m,'uniformoutput',false);
fc = funchain(f{:});
assert(fc(1)==m*(m+1)/2+1);

% test, singleton chain : single input, multiple outputs
f = @(x) deal(x,2*x);
fc = funchain(f);
[a,b] = fc(1);
assert(a==1 && b==2);

% test, singleton chain : check multiple inputs, single output
f = @(x,y) x+y;
fc = funchain(f);
assert(fc(1,2)==3);

% test, singleton chain : check multiple inputs, multiple outputs
f = @(x,y) deal(x,y);
fc = funchain(f);
[a,b] = fc(1,2);
assert(a==1 && b==2);

% test, multiple chain : check multiple inputs, multiple outputs
f1 = @(x,y) x+y;
f2 = @(x) deal(x, 2*x);
fc = funchain(f1,f2);
[a,b] = fc(1,2);
assert(a==3 && b==6);

% test, multiple chain : check multiple inputs, multiple outputs
f1 = @(x,y) deal(x,y);
f2 = @(x,y) deal(x,y);
fc = funchain(f1,[1,2],f2);
[a,b] = fc(1,2);
assert(a==1 && b==2);

% test, multiple chain : parameters passing
f1 = @(x)x;
f2 = @(x,y)x+y;
fc = funchain(f1,{2},f2);
a = fc(1);
assert(a==3);

% test, multiple chain : parameters passing
f1 = @(x,y,z)x+y*z;
f2 = @(x,y)x+y;
fc = funchain({3,4},f1,{2},f2);
a = fc(1);
assert(a==15);

% test, func2str
f1 = @(x,y,z)x+y*z;
f2 = @(x,y)x+y;
fc = funchain({3,4},f1,{2},f2);
a = func2str(fc);
assert(strcmp(a,'funchain({[3][4]},@(x,y,z)x+y*z,[1],{[2]},@(x,y)x+y)'));

