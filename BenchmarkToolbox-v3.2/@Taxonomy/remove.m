function o = remove(o,varargin)
	if(length(varargin)>1)
		for i=1:length(varargin)
			o = o.remove(varargin{i});
		end

		return;
	elseif(isempty(varargin))
		return;
	end

	key = varargin{1};
	if(strcmp(o.name,key))
		o = [];
		return;
	end

	for i=1:length(o.childs)
		c = remove(o.childs{i},key);
		if(isempty(c))
			if(i>1)
				o.childs = o.childs([1:i-1,i+1:end]);
			else
				o.childs = o.childs(2:end);
			end
			if(isempty(o.childs))
				o = [];
			end			
			break;
		else
			o.childs{i} = c;
		end
	end
	
	try
	if(~isempty(o) && length(o.childs)==1 && ~isempty(o.childs{1}.childs))
		o.childs = o.childs{1}.childs;
		for i=1:length(o.childs)
			o.childs{i}.parent = o;
		end
	end
	catch me
		display(o);
		rethrow me;
	end
end