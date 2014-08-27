% First, generate data from a mixture of two bivariate Gaussian
% distributions using the mvnrnd function:
clear;

MU1 = [1 2; 3 4];
LAMBDA = [.6 .4; .2 .8];
SIGMA1 = [2 0; 0 .5];
MU2 = [-3 -5; -7 2];
SIGMA2 = [1 0; 0 1];

L = 1000;

X1 = [mvnrnd(MU1(1,:),SIGMA1,L*LAMBDA(1,1));mvnrnd(MU2(1,:),SIGMA2,L*LAMBDA(1,2))];
X2 = [mvnrnd(MU1(2,:),SIGMA1,L*LAMBDA(2,1));mvnrnd(MU2(2,:),SIGMA2,L*LAMBDA(2,2))];

perm = randperm(L);

X1 = X1(perm,:);
X2 = X2(perm,:);

idxtrain = 1:(L*.8);
idxtest = (L*.8+1):L;

x1train = X1(idxtrain,:);
x2train = X2(idxtrain,:);

x1test = X1(idxtest, :);
x2test =  X2(idxtest, :);
test = [x1test;x2test];

scatter(x1train(:,1),x1train(:,2),10,'.');
hold on;
scatter(x2train(:,1),x2train(:,2),10,'+');



% Next, fit a two-component Gaussian mixture model:
% options = statset('Display','final');
% obj1 = gmdistribution.fit(x1train,2,'Options',options);
% h1 = ezcontour(@(x,y)pdf(obj1,[x y]),[-8 6],[-8 6]);
% 
% obj2 = gmdistribution.fit(x2train,2,'Options',options);
% h2 = ezcontour(@(x,y)pdf(obj2,[x y]),[-8 6],[-8 6]);
% 
% 
% 
% P(:,1) = pdf(obj1,test);
% P(:,2) = pdf(obj2,test);
options = foptions();
mix1 = gmm(2,2,'diag');
mix1 = gmminit(mix1,x1train,options);
mix1 = gmmem(mix1,x1train,options);


mix2 = gmm(2,2,'diag');
mix2 = gmminit(mix2,x2train,options);
mix2 = gmmem(mix2,x2train,options);

P(:,1) = gmmprob(mix1, test);
P(:,2) = gmmprob(mix2, test);

[idx idx] = max(P,[],2);

gc1 = idx(1:end/2) == 1;
bc1 = idx(1:end/2) == 2;

gc2 = idx(end/2+1:end) == 2;
bc2 = idx(end/2+1:end) == 1;

figure();
hold on;

scatter(x1train(:,1),x1train(:,2),5,'black', '.');
scatter(x2train(:,1),x2train(:,2),5,'black', '.');

scatter(x1test(gc1,1),x1test(gc1,2),20,'green', 'o');
scatter(x1test(bc1,1),x1test(bc1,2),20,'red', 'o');

scatter(x2test(gc2,1),x2test(gc2,2),20,'blue', '+');
scatter(x2test(bc2,1),x2test(bc2,2),20,'magenta', '+');
hold off;


% gmmclassify([x1train;x2train],[ones(L*.8,1) ; ones(L*.8,1)*2], ...
%     test, [ones(L*.2,1) ; ones(L*.2,1)*2],2);
