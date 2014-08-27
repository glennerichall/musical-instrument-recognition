function [cfMat, errors, preds] = crossvalgh(fun, X, Y, varargin)
       
    [cvp, order] = process_options(varargin, ...
        'cvpartition', cvpartition(Y(:,end),'kfold',10), ...
        'order', unique(Y(:,end)));
    
    n = length(order);
    m = size(X,1);
    cfMat = zeros(n,n);
    errors = zeros(m,1);  
	preds = zeros(m,1);
    for i=1:cvp.NumTestSets
        idxtest = find(cvp.test(i));
        idxtrain = find(cvp.training(i));

        ytest = Y(idxtest,:);
        xtest = X(idxtest,:);
        ytrain = Y(idxtrain,:);
        xtrain = X(idxtrain,:);

        predictions = fun(xtrain, ytrain, xtest);
		preds(idxtest) = predictions;
        cfMat = cfMat + confusionmat(ytest(:,end),predictions,'order',order);
        
        e = ytest(:,end)~=predictions;
        errors(idxtest(e)) = 1;
    end
    
    errors = logical(errors);
end

