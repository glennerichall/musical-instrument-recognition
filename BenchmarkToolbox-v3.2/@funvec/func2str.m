function str = func2str(o)
	% TODO replace parameter names by values
	% ex {2,3}@(x,y,z) ---> @(x,2=>y,3=>z)
	str = arrayfun(@(f)[tostr(f.parameters) ',' func2str(f.function) ',' ...
		tostr(f.outputs)],o.flist,'uniformoutput',false);
	
	
	for i=1:length(str)
		while(str{i}(1)==',')
			str{i} = str{i}(2:end);
		end		
		while(str{i}(end)==',')
			str{i} = str{i}(1:end-1);
		end
	end
	
	str = strcat(str,',');
	str = [str{:}];
	
	while(str(end)==',')
		str = str(1:end-1);
	end
	
	str = ['funvec(' str ')'];
end