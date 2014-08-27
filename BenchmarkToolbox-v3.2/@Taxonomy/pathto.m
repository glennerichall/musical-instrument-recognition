% FIXME ends with an dot to be removed
function out = pathto(o,varargin)
	if(length(varargin)>1)
		out = cellfun(@o.pathto, varargin,'uniformoutput',false);
		return;
	end
	out = [];

	for i=1:length(o.childs)
		idx = strcmp(o.childs{i}.keys(),varargin{1});
		if(any(idx))
			out = [o.name '.' o.childs{i}.pathto(varargin{:})];
			break;
        elseif(strcmp(o.name,varargin{1}))
            out = o.name;
		end
	end
end