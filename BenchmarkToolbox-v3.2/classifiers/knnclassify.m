function l = knnclassify(xtrain, ytrain, xtest, k) 
% kNN classifier.
% See also crossval, knnfwd, knn
	if(nargin==3)
		k=5;
	end
    if(iscell(xtrain))
        l = cclassify(xtrain, ytrain, xtest, k);
    else
        l = aclassify(xtrain, ytrain, xtest, k);
    end
end


function l = cclassify(xtrain, ytrain, xtest, k)
    nin = cellfun(@(x) size(x,2), xtrain);
    nin = unique(nin);
    if(length(nin)>1)
        error('Feature vectors must all be same size');
    end

    nout = max(ytrain);

    lens = cellfun(@(x) size(x,1), xtrain);
    ytrain = arrayfun(@(i) repmat(ytrain(i),lens(i),1),1:length(ytrain),'uniformoutput',false);
    ytrain = vertcat(ytrain{:});
    models = knn(nin,nout,k,vertcat(xtrain{:}),one_of_N(ytrain,nout));

    l = zeros(size(xtest,1),1);
    for i=1:length(xtest)
        [p, p] = knnfwd(models, xtest{i});
        l(i) = mode(p);
    end
    
end

function l = aclassify(xtrain, ytrain, xtest, k) 
    nin = size(xtrain,2);
    nout = max(ytrain);
	net = knn(nin,nout,k,xtrain,one_of_N(ytrain,nout));
    [l,l] = knnfwd(net,xtest);
end

function o = one_of_N(x,m)
    n = length(x);
    if(size(x,1)~=1)
        A = [n,m];
        ind = sub2ind(A,1:n,x');
    else
        A = [m,n];
        ind = sub2ind(A,x,1:n);
    end
    
    o = zeros(A);
    o(ind) = 1;
end