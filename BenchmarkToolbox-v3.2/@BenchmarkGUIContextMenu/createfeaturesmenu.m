function k = createfeaturesmenu(o,varnames,menu,k)
		
	uimenu(menu,'Checked','on','Label','All Features','Callback',...
		@(src,evt) o.setselection(src,k));

	b = false;
	for vn=varnames
		if(b)
			sep = 'off';
		else
			sep = 'on';
			b=true;
		end		
		if(iscell(vn))
			vn=vn{:};
			uimenu(menu,'Separator',sep,'Checked','on','Label',vn, ...
					'Callback', @(src,evt)o.setselection(src,k));
			
			k=k+1;
		else
			menu2 = uimenu(menu, 'Separator',sep,'Checked','on',...
				'Label',vn.name,'Callback', @(src,evt)o.displayfeatures(src));

			k = o.createfeaturesmenu(vn.varnames,menu2,k);
		end
	end
end	