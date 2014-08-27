function setselection(o,menu,sidx)
	tax = o.bmgui.hittest();
	checked = strcmp(get(menu,'Checked'),'on');
	name = get(menu,'Label');
	
	if(isfield(tax.data,'selection'))
		if(strcmpi(name,'All Features'))
			if(get(menu,'Parent')==o.featuresmenu)
				sidx = 1:length(tax.data.selection);
			else
				n = length(get(get(menu,'Parent'),'children'));
				sidx = sidx:sidx+n-2;
			end
		end
		tax.data.selection(sidx) = ~checked;
	end
	
	if(checked)
		set(menu,'Checked','off');
	else
		set(menu,'Checked','on');
	end
end