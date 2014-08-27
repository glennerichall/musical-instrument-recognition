
function drawrectangles(o,tax,m,style,width)

	% entry point of recursivity
	if(nargin==1)
		keys = o.benchmark.taxonomy.keys;
		m = length(keys);
		o.benchmark.taxonomy.data.rectangle=[0 0 m m];
		o.drawrectangles(o.benchmark.taxonomy,0,'--',...
			o.benchmark.taxonomy.depth);
		return;
	end

	k = m;
	p=0;
	for t = tax.subclasses
		keys = t.keys;
		n = length(keys);
		% end point of recursivity
		if(isempty(t.subclasses))
			k = k+n;
			continue;
		end
		rectangle('Position',[k+.5,k+.5,n,n],'LineStyle',style,'LineWidth',width,'EdgeColor','black','Parent',o.plothandle);
		t.data.rectangle=[k+.5,k+.5,n,n];
		
		o.drawrectangles(t,k,style,width-1);
		k = k+n;
		p = p+n;
	end	
end