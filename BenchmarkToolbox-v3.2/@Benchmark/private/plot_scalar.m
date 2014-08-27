function h = plot_scalar(o,varargin)
	xlsfile = process_options(varargin,'xlsfile',[]);
	if(isempty(xlsfile))
		h = o.results.plot(varargin{:});
	else
		plot_confusion(o.results.confusion,keys,xlsfile);
	end
end
