function display(o)
	for i=1:length(o)
		m = dispp(o(i), 0);
		disp(repmat('-----',1,m*2));
	end
end