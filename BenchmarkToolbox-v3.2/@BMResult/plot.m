function h = plot(o,varargin)
	order = o.order;
	if(isempty(o.confusion))
		if(~isempty(o.order))
			m = length(order);
			confusion = zeros(m);
		else
		confusion = [];
		end
	else
		confusion = o.confusion;
	end
	
	if(~isempty(confusion))
		h = plot_confusion(confusion, order, ...
			'title',{['\bf' o.name '\rm']}, ...
			'FontSize', 10, ...
			'Space', .7,'HAngle',35,varargin{:});	
	else
		h = axes();
		title({['\bf' o.name '\rm']});
		disp(o.name);
	end
end