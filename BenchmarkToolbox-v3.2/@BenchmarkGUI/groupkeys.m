function groupkeys(o)
	tax = o.hittest();
	wb = waitbargh(o.benchmark.kfolds,'window_options',...
		{'WindowStyle','modal'},...
		'isgraphic',true,'time-interval',0,'pourcent-interval',0);	
	% TODO put in Benchmark class
	% remove group
	tkeys = tax.keys;
	if(~isempty(o.benchmark.fileset))
		fkeys = o.benchmark.fileset.keys;
		idx = ismember(fkeys,tkeys);
		fkeys(idx) = {tax.name};
		o.benchmark.fileset.setkeys(fkeys);
        if(~isempty(o.benchmark.featureset))
            o.benchmark.featureset.obsnames = fkeys;		
        end
	end

	if(tax == tax.head())
		tax.crop(1);
	else
		tax.trim(1);
	end
	
	o.benchmark.prepare();

	o.benchmark.validate('waitbar',wb);
	o.display();
end