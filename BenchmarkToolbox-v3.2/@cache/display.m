function display(o)
	disp(o.file);
	if(~isempty(o.cache))
		disp(['Number of elements : ' num2str(length(o.cache.keys))]);
	else
		disp('empty');
	end
	disp(['miss : ' num2str(o.miss)]);
	disp(['hits : ' num2str(o.hits)]);
end