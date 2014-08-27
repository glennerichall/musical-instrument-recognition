function handleclick(o)
	type = get(o.fighandles.output,'SelectionType');
	switch lower(type)
		case 'alt'
			
		case 'open'
			o.plottaxonomy();
		case 'extend'
		case 'normal'
	end
    notify(o,'Clicked');
end