function validatebm(o)
	if(~isempty(o.benchmark))
		wb = waitbargh(o.benchmark.kfolds,'window_options',...
			{'WindowStyle','modal'},...
			'isgraphic',true,'time-interval',0,'pourcent-interval',0);
		o.benchmark.validate('waitbar',wb);
		o.display();
	end
end