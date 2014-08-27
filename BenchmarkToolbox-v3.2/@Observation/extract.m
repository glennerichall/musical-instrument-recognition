function out = extract(o,file)
	for i=1:length(o)
		try
			o(i) = extract_scalar(o(i),file,o(i).cache);
		catch ME
			disp( o(i).name );
			rethrow (ME);
		end
	end
	lens = cellfun(@(x) size(x,1),{o.data});
	o = expand(o,max(lens));
	out = [o.data];
end