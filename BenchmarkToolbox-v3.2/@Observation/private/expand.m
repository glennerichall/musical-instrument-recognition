function o = expand(o,m)
	for i=1:length(o)
		s = size(o(i).data,1);
		n = ceil(m/s);
		o(i).data = repmat(o(i).data,n,1);
		o(i).data = o(i).data(1:m,:);
	end
end