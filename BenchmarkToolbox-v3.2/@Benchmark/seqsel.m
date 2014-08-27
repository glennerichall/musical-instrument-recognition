function seqsel(o,tax,varargin)

	wb = process_options(varargin,'waitbar',[]);
	if(~haschilds(tax))
		return;
	end

	function out = f(xtrain,ytrain,xtest,ytest)
		out = sum(ytest ~= (o.validationfunction(xtrain,ytrain,xtest)));
		if(~isempty(wb))
			wb = update(wb);
		end
	end
	
	
	fs = o.featureset.subset(tax.keys);
	cint = tax.parsekeys(fs.obsnames);
	
	if(o.verbose)
        disp(['selecting features for class ' tax.name]);
        params = {'display','iter'};
    else
        params = {};
	end
	opts = statset(params{:});
	
	keepin = [];
	keepout = [];
	if(isfield(tax.data,'selection') && ~isempty(tax.data.selection))
		if(strcmpi(o.selection,'forward'))
			keepin = tax.data.selection;
		elseif(strcmpi(o.selection,'backward'))
			keepout = ~tax.data.selection;
		end
	end
	
	
	selection = sequentialfs(@f, fs.data, cint(:,1), ...
            'direction',o.selection, 'cv',o.kfolds, ...
            'nfeatures',o.nfeatures,'keepin',keepin,'keepout',keepout,...
			'options',opts);   
		
	tax.data.selection = selection;
	
end