% (1) extrac features
% (2) optimize classifiers
% (3) cross-validate
% (4) plot results
% date : 2012-03-25
% date : 2012-04-26
% author : Glenn-Eric Hall
% rev. 1.0
% rev. 2.0
clear;

%% ========================================================================
% extract the features from files
if(~exist('options','var'))
    makeconfiguration;
end

if(~exist('features','var'))
    filename = [options.environment.cache.basedir filesep 'features.mat'];
    if(~exist(filename,'file'))
    
        % extract the features from files
        disp('loading file names');
        if(~exist('fileset','var'))
            makefileset;
        end
        % creating the feature extractors
        if(~exist('observationvec','var'))
            makeobservations;
        end

        disp('extracting features');    
        features = observationvec.extract(fileset.files,'verbose',options.extraction.verbose);
        
        save(filename,'features');
        clear observationvec fileset;
    else
        load (filename);
    end
    clear filename;
end
% features = features.take(3);
% features = features({'Acoustic Guitar','Banjo','Violin'});
% features = features.take(50);
% features = features.take(options.fileset.maxfile);
%% ========================================================================
% load the mappings
if(~exist('bmtb','var'))
    bmtb = script2struct('makemappings');
%     bmtb = script2struct('makeoptimizations',bmtb);
end

% Direct classification
Mapping.verbose(options.crossvalidation.verbose);
for field=fieldnames(bmtb.mappings.classifier)'
    filename = [options.environment.results.basedir filesep ['optimization.' field{:}] '.mat'];
    if(exist(filename,'file'))
       load (filename);
    else
        tic;
        W =  bmtb.optimization.classifier.(field{:}) *  ...
            [bmtb.Id,bmtb.optimization.transformation.pca] * ...
            bmtb.arrays.normalization * ...
            bmtb.arrays.aggregation;
        if(matlabpool('size') == 0)
            matlabpool open 4;
        end
        opts = statset('UseParallel','always','Display','iter');
        
        if(~exist('cache','var') && options.environment.cache.usecache)
            cache = Cache([options.environment.cache.basedir filesep options.crossvalidation.cache],...
                'autocommit',options.crossvalidation.autocommit);
        else
            cache = [];
        end

        result.(field{:}) = bmtb.Validate.crossval(W,features,'cache',cache,'kfold',options.crossvalidation.kfolds,'options',opts);

        save (filename, 'result');
        toc;
    end
end

% #Graphique : Sélection du nombre de gaussiennes (GMM)
figure();
result.gmm.take('~mean').take('~meantr').take('~pca'). ...
    plot('xlabel','nombre de gaussienne','xtickcapture','(\d+)', ...
    'dcmcapture',@(x) ['nombre de gaussiennes : ' regexp(x,'\d+','once','match')]);
title('Sélection du nombre de gaussiennes (GMM)');

% #Graphique : Sélection du nombre de voisinage (k-NN)
figure();
result.knn.take('~mean').take('~meantr').take('~pca'). ...
    plot('xlabel','nombre de voisins','xtickcapture','(\d+)', ...
    'dcmcapture',@(x) ['nombre de voisins : ' regexp(x,'\d+','once','match')]);
title('Sélection du nombre de voisins (k-NN)');

% #Graphique : Sélection du nombre de gaussiennes (GMM)


% sequential feature selection
for field=fieldnames(result)'
    W =  bmtb.optimization.classifier.(field{:}) *  ...
        [bmtb.Id,bmtb.optimization.transformation.pca] * ...
        bmtb.arrays.normalization * ...
        bmtb.arrays.aggregation;
    
    if(matlabpool('size') == 0)
        matlabpool open 4;
    end
    opts = statset('UseParallel','always','Display','iter');
    
    if(~exist('cache','var') && options.environment.cache.usecache)
        cache = Cache([options.environment.cache.basedir filesep 'sequentialfs-' options.crossvalidation.cache],...
            'autocommit',options.crossvalidation.autocommit);
    else
        cache = [];
    end
    
    bmtb.Validate.wrap(W(idx),'fun',@sequentialfs,'cache',cache,'kfold',options.crossvalidation.kfolds,'options',opts);
    
    save (filename, 'result');    
end

matlabpool close;
% Hierarchic classification


