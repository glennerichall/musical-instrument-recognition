function o = run(o, varargin)
	verbose = any(strcmpi(varargin,'verbose'));

	if(verbose)
		wb =waitbargh(length(o),'message', 'RUN',...
			'time-interval',0,...
			'pourcent-interval',0);
	end

	for i=1:length(o)
		o(i) = run_scalar(o(i),varargin{:});
		if(verbose)
			wb = update(wb);
		end
	end

end	