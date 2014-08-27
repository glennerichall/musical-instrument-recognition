function cint = parsekeys(o,keys)
	n = length(keys);
	m = o.depth();
	cint = zeros(n,m);
	for i=o.depth()-1:-1:0
		o = o.subclasses();
		for j=1:length(o)
			idx = ismember(keys,o(j).keys);
			cint(idx,i+1) = j;
		end
	end
	cint = cint(:,end:-1:1);
end