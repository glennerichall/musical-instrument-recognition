function f = functions(o)
	f = cellfun(@functions,{o.flist.function},'uniformoutput',false);
	
	for i=1:length(f)
		if(~isfield(f{i},'workspace'))
			s = f{i};
			s.workspace = {};
			f{i} = s;
		end
	end
	
	f = [f{:}];
end