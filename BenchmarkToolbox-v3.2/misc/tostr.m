
% this function serves to create a key with the parameters
% TODO to_string of a function
function str = tostr(varargin)
    o = varargin{1};
    
    if(isnumeric(o))
		if(~isempty(o))
			% TODO comma separated list
			str = ['[' num2str(o) ']'];
		else
			str=[];
		end
    elseif(iscell(o) )
        if(~isempty(o))
            str = ['{' tostr(o{:}) '}'];
		else 
			str=[];
        end
    elseif(isstruct(o))
        % recurse for each element in array
        str = tostr(struct2array(o));
    elseif(isa(o,'function_handle'))
        str = func2str(o);
    elseif(ischar(o))
        str = o;
    elseif(islogical(o))
        if(o)
            str = 'true';
        else
            str = 'false';
        end
    else
        str = class(o);
    end

    if(length(varargin)>1)
        % recurse for each element in variable arguments
        str = [str tostr(varargin{2:end})];
    end
end