function resetview(o)
	if(~isempty(o.benchmark))
		o.benchmark = o.benchmarkori.clone();
		o.display();
	end
end
