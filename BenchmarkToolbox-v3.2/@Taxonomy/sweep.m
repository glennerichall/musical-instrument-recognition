
% FIXME use a mechanism to return a value from sweep
% FIXME rename function sweep to taxfun		
function sweep(o,fun,post)
	if(nargin<3)
		post = false;
	end

	if(~post)
		fun(o);
		for i=1:length(o.childs)
			o.childs{i}.sweep(fun,post);
		end
	else
		for i=1:length(o.childs)
			o.childs{i}.sweep(fun,post);
		end		
		fun(o,post);
	end
end