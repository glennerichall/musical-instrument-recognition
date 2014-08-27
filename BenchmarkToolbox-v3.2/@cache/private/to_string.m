% this function serves to create a key with the parameters
function str = to_string(varargin)
    o = varargin{1};

	if(isa(o,'function_handle'))
		str = func2str(o);
	else
	   str = tostr(o);
	end

    if(length(varargin)>1)
        % recurse for each element in variable arguments
        str = [str to_string(varargin{2:end})];
    end
end