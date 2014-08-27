function varargout = subsref(o,s)
	switch s.type
		case '()'
			
			[varargout{1:nargout}] = feval(o,s(1).subs{:});
			
		case '{}'
			% TODO error
			error();
		case '.'
			% TODO error
			error();
	end
end