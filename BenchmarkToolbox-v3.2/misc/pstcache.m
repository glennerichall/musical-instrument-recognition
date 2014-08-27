function o = pstcache(o)
	persistent cache_;

	if(nargin==1)
		cache_ = o;
	end
	
	if(nargout==1)
		o = cache_;
	end
end