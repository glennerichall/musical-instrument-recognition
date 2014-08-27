function out = subclasses(o,varargin)
	out = [o(1).childs{:}];
	for i=2:length(o)
		out = [out o(i).childs{:}];
	end

	if(nargin==2)
		if(iscellstr(varargin))
			idx = ismember({out.name},varargin);
			out = out(idx);
		else
			% TODO error()
		end
	end
end