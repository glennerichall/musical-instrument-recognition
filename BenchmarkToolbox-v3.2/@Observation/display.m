function display(o)
% TODO format display
	for oo=o
		dispp(oo);
	end
end

function dispp(o)
	disp(o.name);
	cellfun(@(x) disp(['    ' x]),o.varnames);
end