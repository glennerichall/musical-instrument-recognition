function [m,n] = size(o,dim)

	if(nargin==1)
		if(iscell(o.data))
			n = size(o.data{1},2);
			m = size(o.data,1);
		else
			[m n] = size(o.data);
		end	
		if(nargout<=1)
			m = [m n];
		end
	elseif(nargout==1)
		if(iscell(o.data))
			m = size(o.data{1},dim);
		else
			m = size(o.data,dim);
		end
	else
		error('Unknown command option.');
	end
end