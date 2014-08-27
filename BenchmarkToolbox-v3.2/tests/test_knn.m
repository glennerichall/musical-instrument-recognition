clearvars;

%% one frame per observation
MU1 = [1 2; 3 4];
SIGMA1 = [2 0; 0 .5];
MU2 = [-3 -5; -7 2];
SIGMA2 = [1 0; 0 1];

L = 1000;

X1 = mvnrnd(MU1(1,:),SIGMA1,L);
X2 = mvnrnd(MU1(2,:),SIGMA1,L);

perm = randperm(L);

X1 = X1(perm,:);
X2 = X2(perm,:);

idxtrain = 1:(L*.8);
idxtest = (L*.8+1):L;

x1train = X1(idxtrain,:);
x2train = X2(idxtrain,:);
train = [x1train;x2train];

x1test = X1(idxtest, :);
x2test =  X2(idxtest, :);
test = [x1test;x2test];

scatter(x1train(:,1),x1train(:,2),'SizeData',10,'Marker','.');
hold on;
scatter(x2train(:,1),x2train(:,2),'SizeData',10,'Marker','+');

ctrain = [repmat(2,L*.8,1);repmat(3,L*.8,1)];
ctest = [repmat(2,L*.2,1);repmat(3,L*.2,1)];

predictions = knnclassify(train,ctrain,test,20);

goodp1 = test(predictions==2 & predictions==ctest,:);
badp1 = test(predictions==2 & predictions~=ctest,:);
goodp2 = test(predictions==3 & predictions==ctest,:);
badp2 = test(predictions==3 & predictions~=ctest,:);

figure();
scatter(goodp1(:,1),goodp1(:,2),10,'o','MarkerEdgeColor','blue');
hold on;
scatter(badp1(:,1),badp1(:,2),10,'o','MarkerEdgeColor','red');
scatter(goodp2(:,1),goodp2(:,2),10,'+','MarkerEdgeColor','green');
scatter(badp2(:,1),badp2(:,2),10,'+','MarkerEdgeColor','red');

%% multi frame per observation

X1 = [1 2; 2 2; 1 3; 2 3];
X2 = [11 12 ; 12 12 ; 11 13; 12 13; 14 15];
scatter(X1(:,1),X1(:,2),10,'Marker','o');

scatter(X2(:,1),X2(:,2),10,'Marker','+');

predictions = knnclassify({X1;X2}, [1;2], {X1;X2}, 2);

