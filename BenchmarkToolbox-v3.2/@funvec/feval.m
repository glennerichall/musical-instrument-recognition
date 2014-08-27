function varargout = feval(o,varargin)
	
	n=1;

	for f=o.flist
		nout = length(f.outputs);
		clear out;
		[out{1:nout}] = f.function(varargin{:},...
			f.parameters{:});
		
		varargout(n:n+nout-1) = out(f.outputs);
		n = n+nout;
	end
	
	if(o.catresult)
		varargout = {[varargout{:}]};
	elseif(~iscell(varargout))
		varargout = {varargout};
	end
end