function o = groupBy(s,varargin)
    field = {s.(varargin{1})};
    o = cellfun(@(x) s(strcmpi(field,x)),unique(field), ...
        'UniformOutput',false);
    
    if(length(varargin)>1)
        o = cellfun(@(x) groupBy(x, varargin{2:end}), o, ...
            'UniformOutput',false);
    end
        
end