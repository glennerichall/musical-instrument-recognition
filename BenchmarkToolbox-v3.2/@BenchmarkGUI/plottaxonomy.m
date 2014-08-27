function plottaxonomy(o)
	
	tax = o.hittest();
	if(isfield(tax.data,'result'))
		figure();
		tax.data.result.plot();
	end
end