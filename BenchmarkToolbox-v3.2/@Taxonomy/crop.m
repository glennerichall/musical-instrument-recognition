function o = crop(o,l1,l2)
	if(nargin==2)
		l2 = o.depth();
	end

	if(l1==1)
		o.childs = num2cell(o.level(l2+1));
		for i=1:length(o.childs)
			o.childs{i}.parent = o;
		end
	else
		for i=1:length(o.childs)
			o.childs{i} = crop(o.childs{i},l1-1,l2-1);
		end
	end
	
	notifyhead(o,'Changed');
end