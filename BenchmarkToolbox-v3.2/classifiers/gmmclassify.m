function l = gmmclassify(xtrain, ytrain, xtest, k)
	if(nargin==3)
		k=5;
	end
% FIXME trouver un moyen + elegant de selectinner la maniere de predire
% ente des cells et des arrays
	if(~iscell(xtrain))
		l = agmmclassify(xtrain, ytrain, xtest, k);
	else
		l = cgmmclassify(xtrain, ytrain, xtest, k);
	end
end

function l = cgmmclassify(xtrain, ytrain, xtest, k)

    % get indices of each group of classes in ytrain
    parts = arrayfun(@(x) find(ytrain==x),unique(ytrain), ...
		'UniformOutput',false);
    
    % fit a gaussian mixture for each classes
    m = length(parts);
    obj = cell(1,m);
    options = foptions();
    for i=1:m
		obs = vertcat(xtrain{parts{i}});
		dim = size(obs,2);
        obj{i} = gmm(dim,k,'diag');
        obj{i} = gmminit(obj{i},obs,options);
        obj{i} = gmmem(obj{i},obs,options);
    end
   
    % find the probability density of each model for each observation in xtest
    P = zeros(length(xtest),m);
    for i=1:m
		for j=1:length(xtest)
			obs = xtest{j};
			P(j,i) = sum(log(gmmprob(obj{i},obs)));
		end
    end
    
    % predictions
    [l l] = max(P,[],2);
end

function l = agmmclassify(xtrain, ytrain, xtest, k)

    % get indices of each group of classes in ytrain
    parts = arrayfun(@(x) find(ytrain==x),unique(ytrain), ...
		'UniformOutput',false);
    
    % fit a gaussian mixture for each classes
    m = length(parts);
    obj = cell(1,m);
    
	options = foptions();
    dim = size(xtrain,2);
    for i=1:m
		obs = xtrain(parts{i},:);
        obj{i} = gmm(dim,k,'diag');
        obj{i} = gmminit(obj{i},obs,options);
        obj{i} = gmmem(obj{i},obs,options);
    end
   
    % find the probability of each model for each observation in xtest
    P = zeros(length(xtest),m);
    for i=1:m
        P(:,i) = gmmprob(obj{i},xtest);
	end
	
	% predictions
    [l l] = max(P,[],2);
end