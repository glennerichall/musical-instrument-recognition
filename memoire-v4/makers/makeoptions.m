mirverbose(0);
mirwaitbar(0);

% framework options-------------------------------------------------------
% CROSS-VALIDATION
% cross-validation
crossvalidation.kfolds = 10;                       % number of cross validation folds
crossvalidation.verbose = true;                    % verbose while cross-validating
% crossvalidation.classifiers = {'knn','gmm','svm','fda'};             % used classifiers in cross-validations : {knn,gmm,svn,fda}
% crossvalidation.votingscheme = 'best';              % voting scheme for used classifiers : best, mode
crossvalidation.cache = 'cache-mappings.mat';
crossvalidation.autocommit = 1;

% feature reduction
% reduction.algorithm = 'sequentialfs[backward]';    % reduction algorithm : sequentialfs[forward], sequentialfs[backward], pca[n]
% reduction.verbose = true;                          % verbose while executing feature reduction

% ENVIRONMENT
environment.cache.usecache = true;
environment.basedir = 'uqac-data';
environment.data.basedir = 'data\segmented\rwc';
% environment.results.file = 'taxonomy';


extraction.cache = 'cache-observations.mat';
extraction.autocommit = 100;
extraction.verbose = true;
extraction.aggregetaion = {};

% User defined options ---------------------------------------------------
% taxonomy
hierarchy.taxonomy = 'maketaxonomymartin';

% FILESET
fileset.cache = 'cache-files.mat';
fileset.maxfile = inf;   % number of files to use for each class
fileset.extension = '.wav';
fileset.articulations = { % this will exclude harp and others
    'NO', ...           % normal articulation
    'LP','AP', ...      % plucked guitars
    'FI','NA', ...      % plucked ukulele and banjo
    'PN','PS'};         % electric bass
fileset.dynamics = {'F','M'}; % forte and mezzo
fileset.maxlength = 8e5;
fileset.minlength = 2e4;

% % hierarchies
% validation.hierarchies.direct = 'direct';
% validation.hierarchies.natural = 'martin';
% validation.hierarchies.naturalmodified = 'modifiedmartin';
% validation.hierarchies.kmeansclusters = 'clusters';
% validation.hierarchies.taxonomy = validation.hierarchies.(options.options.hierarchy.taxonomy);
% % agregetations
% validation.frames.collapsed = 'collapsed';
% validation.frames.fullframes = 'fullframes';
% % normalizations
% validation.normalization.musigma = 'musigma';
% validation.normalization.minmax = 'minmax';
% validation.normalization.none = [];