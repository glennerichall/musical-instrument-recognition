% Specify default values for options
% date : 2011-12-14
% author : Glenn-Eric Hall
% rev. 1.0

% extraction
extraction.verbose = false;
extraction.aggregetaion = {@mean,@std,@slope};
extraction.autocommit = -1;
extraction.cache = [];


% cross-validation
crossvalidation.kfolds = 10;                                % number of cross validation folds
crossvalidation.verbose = false;                            % verbose while cross-validating
% crossvalidation.classifiers = {'knn','gmm','svm','fda'};    % used classifiers in cross-validations : {knn,gmm,svn,fda}
% crossvalidation.votingscheme = 'mode';                      % voting scheme for used classifiers : bestclassifier, mode
crossvalidation.randstream = RandStream('mt19937ar', 'Seed',0);

%% REDUCTION
% reduction.randstream = RandStream('mt19937ar', 'Seed',0);
% reduction.algorithm = 'sequentialfs.backward';     % reduction algorithm : sequentialfs[forward], sequentialfs[backward], pca[n]
% reduction.verbose = false;                          % verbose while executing feature reduction

%% ENVIRONMENT

environment.drive = 'c:';
environment.basedir = 'benchmarktoolbox';

environment.data.basedir = 'data';
environment.data.extension = '.mat';

environment.cache.usecache = false;
environment.cache.basedir = 'cache';
% environment.cache.file = 'benchmark-cache';
% environment.cache.extension = '.mat';

environment.results.basedir = 'results';
environment.results.extension = '.xlsm';
environment.results.file = 'confusion';

%% ALGORITHMS
% parameters
% classifiers.parameters.knn = {4};
% classifiers.parameters.gmm = {4};
% classifiers.parameters.svm = {'rbf'};
% classifiers.parameters.fda = {'linear'};
% reduction.parameters.pca = {34};
% reduction.parameters.sequentialfs.forward = {'direction','forward'};
% reduction.parameters.sequentialfs.backward = {'direction','backward'};
