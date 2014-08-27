function varargout = cartprod(varargin)
% FIXME optimize
    idx = cellfun(@ischar,varargin);
    for i=find(idx)
        varargin{i} = {varargin{i}};
    end
    lens = cellfun(@length,varargin);
    vec = [varargin{:}];
    v = mat2cell(1:length(vec),1,lens);
    o = vec(combvec(v{:}));
    varargout = arrayfun(@(n) {o{:,n}},1:size(o,2),'uniformoutput',false);
    
    if(nargout <= 1)
        varargout = {varargout};
    end
end