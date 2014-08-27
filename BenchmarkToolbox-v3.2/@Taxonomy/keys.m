function k = keys(o)
	if(length(o)>1)
		for i=1:length(o)
			k{i} = o(i).keys();
		end
		k = [k{:}];
	else
		if(isempty(o.childs))
			if(~isempty(o.name))
				k = {o.name};
			else
				k = [];
			end
		else
			k = cellfun(@keys, o.childs, 'uniformoutput',false);
			k = [k{:}];
		end
	end
end