
% k-NN parameters
classifier.knn.K = [2:8,10:10:50,100]';
classifier.knn.Distance = {'euclidean','seuclidean','cityblock','chebychev',...
    'minkowski','cosine','correlation','spearman','hamming','jaccard'};

% GMM parameters
classifier.gmm.K = [2:12,15,20];

% SVM parameters
classifier.svm.kernel_function = {'linear','quadratic','polynomial','rbf','mlp'}';
classifier.svm.method = {'LS'};

% LDA parameters
classifier.lda.type = {'linear','diaglinear'};

% Sequential Feature Selection
reduction.sequentialfs.direction = {'forward','backward'};

% PCA transformation
transformation.pca.K = 10:30;