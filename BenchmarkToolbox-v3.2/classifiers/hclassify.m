function [o, history] = hclassify(fun, xtrain, ytrain, xtest, varargin)
% hierarchic classifier.
%  predictions = hclassify(fun, xtrain, xtest, ytest,'inmodel', selected_features);
% does a classification of xtest using model created with function fun and 
% data xtrain and ytrain.
% 
% See also crossval, knnclassify, gmmclassify

    [inmodel outputhistory] = process_options(varargin, ...
        'inmodel', [], 'outputhistory', false);
    
    % if no features chosen, select all features for all stages of
    % hierarchy
    if(isempty(inmodel))
% TODO         
%         if(iscell(xtrain))
%             sz = cellfun(@(x) size(x,2), xtrain);
%             sz = unique(sz);
%             if(length(sz)>1)
%                 error();
%             end
%         end
        
        inmodel{1}{1} = true(1,size(xtrain,2));
        for i=1:size(ytrain,2)-1
            for j=1:length(unique(ytrain(:,i)))
                inmodel{i+1}{j} = true(1,size(xtrain,2));
            end
        end        
    end
    

    history = zeros(size(xtest,1),size(ytrain,2));

    % first stage of hierarchy
    im = inmodel{1}{1};
    l = fun(xtrain(:,im), ytrain(:,1), xtest(:,im));
    history(:,1) = l;
    
    
    % for each stage, train by class groups ex:
    % stage:    1    2 
    % classes:  A    A1    
    %           A    A2
    %           B    B1
    %           B    B2
    %  classify by stage 1 and then by stage 2, group A followed by group B
    for c=2:size(ytrain,2)
        k=1;
        for x=unique(ytrain(:,c-1))' % for each class in previous level
            idxtrain = ytrain(:,c-1)==x; % indices of previous level training data
            idxtest = history(:,c-1)==x; % indices of previous level predictions
            im = inmodel{c}{x};			 % variable selection of current level
            
            % if train classes contains only one element, then all test
            % elements must be classified that unique type
            u = unique(ytrain(idxtrain,c));
            if(length(u)>1)
                l = fun(xtrain(idxtrain,im), ytrain(idxtrain,c), xtest(idxtest,im));
            else
                l = ones(sum(idxtest),1)*u;
            end
            history(idxtest,c) = l;  
            k=k+1;
        end       
    end
    
    if(outputhistory)
        o = history;
    else
        o = history(:,end);
    end
end