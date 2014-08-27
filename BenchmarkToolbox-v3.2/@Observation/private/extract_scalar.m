function o = extract_scalar(o,file,cache)
	if(~isempty(cache))
        [o.cache o.data] = fetch(cache,o.extractionfunction,file,o.parameters{:});
    else
        o.data = o.extractionfunction(file,o.parameters{:});
	end
	
	if(~isempty(o.stats) && size(o.data,1)>1)
		if(iscell(o.stats))
			o.data = feval(funvec(o.stats{:},'catresult'),o.data);
		else
			o.data = o.stats(o.data);
		end
	end
end