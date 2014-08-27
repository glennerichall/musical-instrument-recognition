
function displayfeatures(o,menu)
	tax = o.bmgui.hittest();
	
	if(isfield(tax.data,'selection'))
		selection = tax.data.selection;
	else
		selection = true;
	end
	% features menu activated
	if(menu==o.featuresmenu)
		childs = get(menu,'children');
		
		for ch=childs'
			if(strcmpi(get(ch,'Label'),'All Features'))
				if(all(selection))
					set(ch,'Checked','on');
				else
					set(ch,'Checked','off');
				end
			end
		end
		
	% submenu of features menu
	else
		setcheck(menu,o.bmgui.varnames,selection);
	end
	
end

function setcheck(menu,varnames,selection)
	childs = get(menu,'children');
	
	% varnames is a cell string
	if(isempty(childs))
		if(~iscellstr(varnames))
			varnames = varnames.varnames;
		end
		
		% check if submenu is one of the seleced variables
		idx = strcmp(varnames(selection),get(menu,'Label'));

		if(any(idx))
			set(menu,'Checked','on');
			
		% check if it is the 'All Features' menu
		elseif(strcmp(get(menu,'Label'),'All Features'))
			if(all(selection))
				set(menu,'Checked','on');
			else
				set(menu,'Checked','off');
			end
		
		% uncheck the menu
		else
			set(menu,'Checked','off');
		end
		
	% varnames are contained in a struct array with fields name and
	% varnames
	else
		k=1;
		for i=1:length(varnames)

			if(strcmp( varnames(i).name, get(menu,'Label')))
				idx=k:k+length(varnames(i).varnames)-1;
				for c=childs'
					setcheck(c,varnames(i),selection(idx));	
				end
			end
			k=k+length(varnames(i).varnames);
		end
	end
end

