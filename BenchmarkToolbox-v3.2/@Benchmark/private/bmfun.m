function r = bmfun(func, o, varargin)
    for i=1:length(o)
        r(i) = func(o(i), varargin{:});
    end
end