function p = path(o)
	p = [];
	while (~isempty(o.parent))
		p = [o.name '.' p ];
		o = o.parent;
	end
	p = p(1:end-1);
end