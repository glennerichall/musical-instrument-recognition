function removeclass(o)
	wb = waitbargh(o.benchmark.kfolds,'window_options',...
		{'WindowStyle','modal'},...
		'isgraphic',true,'time-interval',0,'pourcent-interval',0);

	o.benchmark.taxonomy.removenode(o.hittest().path);
	o.benchmark.prepare();
	o.benchmark.validate('waitbar',wb);
	o.display();	
end