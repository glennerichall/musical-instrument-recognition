function dispp(o)
    
    disp(['name      : ' o.name]);
    disp(['files     : ' num2str(length(o.fileset.files))]);
	if(~isempty(o.taxonomy))
		disp(['classes   : ' num2str(o.taxonomy.depth)]);
	end
    disp(['folds     : ' num2str(o.kfolds)]);
    % TODO disoplay nothing if empty
    disp(['features  : ' num2str(size(o.featureset,2))]);
    if(isnumeric(o.selection) || islogical(o.selection))
         disp(['selection : ' mat2str(o.selection)]);
    else 
        disp(['selection : ' o.selection]);
    end
    disp(['miss rate : ' num2str(o.missrate)]);
end