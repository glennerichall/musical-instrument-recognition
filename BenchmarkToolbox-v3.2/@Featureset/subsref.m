function varargout = subsref(o,s)
	if(length(s)==1 && strcmp(s.type,'()'))
		varargout = {subset(o,s.subs{:})};
	elseif(strcmp(s(1).type,'{}') )
		o = subset(o,s.subs{:});
		if(length(s.subs)==1)
			varargout = {o.data};
		elseif(length(s.subs)==2)
			varargout = {o.data};
		end
	else
		error();
	end
end