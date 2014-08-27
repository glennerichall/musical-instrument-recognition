function m = dispp(o,n)
    
    spaces = repmat('|    ',1,n);
% 	if(~isempty(o.selection) && o.displayselection)
% 		disp([spaces o.name ' --> ' mat2str(o.selection)]);
% 	else
		disp([spaces o.name]);
% 	end
    m = n;

	for i=1:length(o.childs)
		m = dispp(o.childs{i}, n+1);
		m = max(n,m);
	end

end