function nout = nargout(o)
	if(isempty(o.flist(end).outputs))
		nout = nargout(o.flist(end).function);
	else
		nout = length(o.flist(end).outputs);
	end
end