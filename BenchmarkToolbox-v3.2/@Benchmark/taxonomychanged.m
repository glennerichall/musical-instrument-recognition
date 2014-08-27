function taxonomychanged(o,src,evt)
	if(~isempty(o.taxlster))
		delete(o.taxlster);
	end
	o.prepare();
	o.taxlster = o.taxonomy.addlistener('Changed',@(scr,evt)o.prepare());
end