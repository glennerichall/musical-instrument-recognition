function o = normalize(o)
	% FIXME generalize to any type of class ex: Observation
	if(iscell(o.data))
		data = vertcat(o.data{:});
		mu = mean(data);
		sigma = std(data);

		for i=1:size(o.data,1)
			o.data{i} = bsxfun(@minus,o.data{i},mu);
			o.data{i} = bsxfun(@rdivide,o.data{i},sigma);
		end
	else
		mu = mean(o.data);
		sigma = std(o.data);
		o.data = bsxfun(@minus,o.data,mu);
		o.data = bsxfun(@rdivide,o.data,sigma);
	end
end