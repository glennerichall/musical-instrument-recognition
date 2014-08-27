function evalif(value,funtrue,funfalse,varargin)
    if(nargin>2 && ~isa(funfalse,'function_handle'))
        varargin = {funfalse, varargin{:}};
    end
    
    if(value)
        funtrue(varargin{:});
    elseif(nargin>2 && isa(funfalse,'function_handle'))
        funfalse(varargin{:});
    end
end

