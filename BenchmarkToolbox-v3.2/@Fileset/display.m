function display(o)
	if(isempty(o))
		display('empty fileset');
		return;
	end

    keys = {o.sfiles.key};
    for key=unique(keys)
        idx = strcmp(keys,key);
        disp ([key{:} ':  ' num2str(sum(idx))]);
    end
    disp('--------------');
    disp(['total :  ' num2str(length(o.sfiles))]);
end