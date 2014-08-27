function b = haschilds(o)
	for i=1:length(o)
		b(i) = ~isempty(o(i).childs);
	end
end