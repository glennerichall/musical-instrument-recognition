function savebm(o, filename)
	for i=1:length(o)
		s = o(i);
		save(filename,'s');
	end
end	