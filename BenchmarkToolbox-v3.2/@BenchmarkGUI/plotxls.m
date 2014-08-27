function plotxls(o,ind)
	
	if(ind)
		tax = o.hittest();
		if(isfield(tax.data,'result'))
			conf = tax.data.result.confusion;
			order = tax.data.result.order;
		end
	else
		tax = o.benchmark.taxonomy;
		conf = o.benchmark.results.confusion;
		order = o.benchmark.results.order;
	end

	plot_confusion(conf,order,['c:\temp\' tax.name '.xlsm']);
	dos(['c:\temp\' tax.name '.xlsm']);	
end