% -------------------------------------------------------------------------
% Classifier functions
classifier.gmm.train = @gmmtrain;               % Gaussian Mixture Model
classifier.knn.train = @knntrain;               % K-Nearest Neighbours
classifier.svm.train = @mcsvmtrain;             % Support Vector Machines
classifier.lda.train = @ldatrain;               % Discriminant Analysis

classifier.gmm.map = @gmmpredict;
classifier.knn.map = @knnpredict;
classifier.svm.map = @mcsvmpredict;
classifier.lda.map = @ldapredict;

% Voting scheme functions
% voting.mode = @(x) mode(x,2);                     % Mode of classifiers
% voting.best = @(x,results) x(:,argmin(results));  % Best scoring classifier, results are missrates of each classifiers
% voting.modeofbest = @(x,n,results) mode(x(:,takeoutput(@sort,2,results)),2);   % Mode of n best scoring classifiers

% -------------------------------------------------------------------------
% Normalization
normalizationfun = @(data,a,b) bsxfun(@rdivide,bsxfun(@minus,data,a),b);
% min-max [-1,1] normalization
normalization.minmax.train = @(data){min(data),max(data)};
normalization.minmax.map = @(data,minmax) normalizationfun(data,(minmax{2}+minmax{1})/2,(minmax{2}-minmax{1})/2); 
% mu-sigma normalization
normalization.musigma.train = @(data){mean(data),std(data)};
normalization.musigma.map = @(data,musgima)normalizationfun(data,musgima{1},musgima{2});   
% max(abs) normalization
normalization.absmax.train = @(data) max(abs(data)); 
normalization.minmax.map = @(data,minmax) bsxfun(@rdivide,data,minmax);

clear normalizationfun;


% -------------------------------------------------------------------------
% Transformations
transformation.pca.train = @(x,varargin) take(princomp(double(x)),':',1:varargin{find(strcmp(varargin,'K'))+1});           % Principal Component Analysis (PCA) reduction
transformation.pca.map = @mtimes;               % Linear transformation 


% -------------------------------------------------------------------------
% Dimensionality reduction functions 
% reduction.sequentialfs.train = @(data,fun,varargin) sequentialfs(fun,data,varargin{:},'options',statset('Display','iter','UseParallel','always')); % Sequential Feature Selection (SFFS and SBFS)
% reduction.sequentialfs.map = @(X,selection) X(:,selection);     % Selected features

% -------------------------------------------------------------------------
% Feature category selection functions
selection.category.train = @(data,varargin) ~cellfun(@isempty,regexp(data.varnames,tostr(varargin,'separator','|'),'once'));
selection.category.map = @(data,selection) data(:,selection);

% -------------------------------------------------------------------------
% Frame aggregation functions 
aggregation.mean.train = @(x)@mean;
aggregation.mean.map = @aggregate;

aggregation.meantr.train = @(x)@mean;
aggregation.meantr.map = @aggregate;
aggregation.meantr.trainonly = true;
