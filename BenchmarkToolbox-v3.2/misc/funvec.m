function out = funvec(varargin)
    flist = varargin;
    out = @(varargin) cellfun(@(f) f(varargin{:}),flist,'uniformoutput',false);
end