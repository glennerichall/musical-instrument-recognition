function out = removenode(o,path)
	out = o;
	if(isempty(path))
		return;
	end
	
	if(~isa(path,'Taxonomy'))
		path = strsplit(path,'.');

		for i=1:length(path)
			o = o.subclasses(path{i});
		end
	else
		o = path;
	end


	if(isempty(o) || isempty(o.parent))
		return;
	end
	
	for i=1:length(o.parent.childs)
		if(o.parent.childs{i}==o)
			if(i>1)
				o.parent.childs = o.parent.childs([1:i-1,i+1:end]);	
			else
				o.parent.childs = o.parent.childs(2:end);
			end
			break;
		end
	end

	if(~isempty(o.childs))
		childs = o.parent.childs;
		if(i>1)
			o.parent.childs = [childs(1:i-1) o.childs childs(i:end)];
		else
			o.parent.childs = [o.childs childs];
		end
		for i=1:length(o.parent.childs)
			o.parent.childs{i}.parent = o.parent;
		end
	end
	
	notifyhead(o,'Changed');
end