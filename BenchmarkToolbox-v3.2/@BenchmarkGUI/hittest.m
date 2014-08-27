function out = hittest(o,tax,xyz)
	
	% entry point of recursivity
	if(nargin==1)
		xyz = get(o.plothandle,'CurrentPoint');
		out = o.hittest(o.benchmark.taxonomy, xyz);
		return;
	end

	% end point of recursivity
	if(isempty(tax.subclasses) || isempty(tax.data))
		out=[];
		return;
	end

	x = xyz(1,1);
	y = xyz(1,2);
	
	% check if the current taxonomy is missed
	miss = x<tax.data.rectangle(1) || ...
		x>tax.data.rectangle(1)+tax.data.rectangle(3);
	miss = miss || y<tax.data.rectangle(2) || ...
		y>tax.data.rectangle(2)+tax.data.rectangle(4);	
	
	% taxonomy is missed, continue recursivity
	if(miss)
		out = [];
		return;
	end
		
	% from here the taxonomy is hit
	% check if one of children is hit too
	for t=tax.subclasses
		out = o.hittest(t,xyz);
		if(~isempty(out)),break,end;
	end
	
	% if no children is hit, then this is the taxonomy seeked
	if(isempty(out))
		out = tax;
	end
end