function d = depth(o)
	if(isempty(o.childs))
		d = 0;
	else
		d = cellfun(@depth,o.childs);
		d = max(d)+1;	
	end
end