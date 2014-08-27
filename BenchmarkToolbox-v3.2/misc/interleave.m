function o = interleave(varargin)
	% TODO numeric interleave
	n = length(varargin);
	m = length(varargin{1});
	%TODO error();
	assert(all(cellfun(@length,varargin)==length(varargin{1})));
	
	for i=1:n
		[o{i:n:m*n}] = deal(varargin{i}{:});
	end
end