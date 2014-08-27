function o = level(o,l,varargin)
	if(l==0)
		return;
	end
	idx = haschilds(o);  
	if(all(idx))
		o = o(idx).subclasses();
	elseif(any(idx))
		k=1;
		for i=1:length(idx)
			if(idx(i))
				oo = o(i).subclasses();
				for j=1:length(oo)
					tmp(k)=oo(j);
					k=k+1;
				end
			else
				tmp(k) = o(i);
				k=k+1;
			end
		end
		o = tmp;
	end

	o = o.level(l-1,varargin{:});
end