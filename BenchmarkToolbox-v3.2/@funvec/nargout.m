function nout = nargout(o)
	if(o.catresult)
		nout = 1;
	else
		nout = sum(cellfun(@nargout,{o.flist.function}));
	end
end