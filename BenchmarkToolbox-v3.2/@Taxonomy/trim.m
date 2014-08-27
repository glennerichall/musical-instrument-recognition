function o = trim(o,l)
	oo = o.level(l-1);

	for i=1:length(oo)
		oo(i).childs = {};
	end
	notifyhead(o,'Changed');
end