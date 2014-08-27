% First, generate data from a mixture of two bivariate Gaussian
% distributions using the gmmsamp function:
clear;
clc;

gmix = gmm(2, 2, 'spherical');
gmix.priors = [0.2 0.8];
gmix.centres =  [0.3 0.3; 0.7 0.7]; 
gmix.covars = [0.01 0.01];
samp1 = gmmsamp(gmix,1000);

gmix = gmm(2, 2, 'spherical');
gmix.priors = [0.4 0.6];
gmix.centres =  [0.7 0.3; 1.3 0.4]; 
gmix.covars = [0.01 0.03];
samp2 = gmmsamp(gmix,1000);


% % plot data
% scatter(samp2(:,1),samp2(:,2),10,'o');
% hold on;
% scatter(samp1(:,1),samp1(:,2),10,'+');


% create train and test set
k=2;
train = [samp1(1:800,:);samp2(1:800,:)];
ytrain = [ones(800,1) ; ones(800,1)*2];
test = [samp1(801:end,:);samp2(801:end,:)];
ytest = [ones(200,1) ; ones(200,1)*2];

% test gmmclassify
preds = gmmclassify(train,ytrain,test,k);
cfmat = confusionmat(ytest, preds);
disp(cfmat);
missrate = 1-trace(cfmat)/sum(cfmat(:));
disp(missrate);

%% 
clear;

gmix = gmm(2, 2, 'spherical');
gmix.priors = [0.2 0.8];
gmix.centres =  [0.3 0.3; 0.7 0.7]; 
gmix.covars = [0.01 0.01];
samp1 = gmmsamp(gmix,1000000);

gmix = gmm(2, 2, 'spherical');
gmix.priors = [0.4 0.6];
gmix.centres =  [0.7 0.3; 1.3 0.4]; 
gmix.covars = [0.01 0.03];
samp2 = gmmsamp(gmix,1000000);

c1 = mat2cell(samp1,repmat(1000,1,1000),2);
c2 = mat2cell(samp2,repmat(1000,1,1000),2);

k=2;
train = [c1(1:800,:);c2(1:800,:)];
ytrain = [ones(800,1) ; ones(800,1)*2];
test = [c1(801:end,:);c2(801:end,:)];
ytest = [ones(200,1) ; ones(200,1)*2];

% test gmmclassify
preds = gmmclassify(train,ytrain,test,k);
cfmat = confusionmat(ytest, preds);
disp(cfmat);
missrate = 1-trace(cfmat)/sum(cfmat(:));
disp(missrate);

