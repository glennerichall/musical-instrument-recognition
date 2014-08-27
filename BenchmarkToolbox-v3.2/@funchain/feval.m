function varargout = feval(o,varargin)
       
	% find fargs[i] options
	strs = find(cellfun(@ischar,varargin));
	toks = regexp(varargin(strs),'fargs\[(\d*)\]','tokens');

	% find function number of fargs options
	toksidx = ~cellfun(@isempty,toks);
	argsidx = strs(toksidx);

	% find functions numbers containing parameters
	funcs = cellfun(@(x) str2num(x{1}{1}),toks(toksidx));

	% concatenate fargs to parameters for functions in chain
	for i=funcs
		% TODO
	end

	varargout = varargin; 

	if(isempty(o.flist(end).outputs))
		o.flist(end).outputs = 1:nargout;
	end
	
	% do the function composition by chaining outputs to inputs
	for f=o.flist
		varargin = varargout;
		clear varargout;
		[varargout{1:max(f.outputs)}] = ...
			f.function(varargin{:}, f.parameters{:});
	end
	
	if(~iscell(varargout))
		varargout = {varargout};
	end
end