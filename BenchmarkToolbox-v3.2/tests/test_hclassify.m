
clearvars;
clc;
y(1,:) = [1,   1,   1,   1,   2,   2,   2,   2,   3, 3];
y(2,:) = [11,  11,  12,  12,  21,  21,  22,  22,  3, 3];
y(3,:) = [111, 112, 121, 122, 211, 212, 221, 222, 3, 3];
y = y';

[x1,x2] = meshgrid(1:7,1:10);
x = x1+x2*10;

inmodel{1}{1} = [1];
inmodel{2}{1} = [2];
inmodel{2}{2} = [3];
inmodel{3}{1} = [4];
inmodel{3}{2} = [5];
inmodel{3}{3} = [6];
inmodel{3}{4} = [7];

% fun = @(xtrain, ytrain, xtest, ytest) ytrain(randi(size(ytrain,1)-1, size(xtest,1),1)+1);

fun = @(xtrain, ytrain, xtest) ytrain;

[l,h] = hclassify(fun,x,y,x);

assert(all(l == y(:,end)));
assert(all(all(h == y)));
% xx = [xx{:}];
% xx = [xx{:}];
% assert(all(xx));
% 
% 
% assert(length(xx)== 7*7);
% 
% [l, xx] = hclassify(fun,x,y,x,y,'inmodel', inmodel);
% 
% xx = [xx{:}];
% xx = [xx{:}];
% assert(sum(xx) == 7+6+5+4+3+2+1);
% 
disp('all good');
% 
