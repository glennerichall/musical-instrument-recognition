function out = clone(o)
	out = Taxonomy();
	out.childs = cellfun(@clone, o.childs,'uniformoutput',false);
	out.name = o.name;
	out.data = o.data;
	for i=1:length(out.childs)
		out.childs{i}.parent = out;
	end
end