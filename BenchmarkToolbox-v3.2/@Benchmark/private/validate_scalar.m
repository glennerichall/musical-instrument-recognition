function o = validate_scalar(o,varargin)
	if(isempty(o.featureset))
		% TODO EmptyFeatureet events notofication
		return;
	end
	
	wb = process_options(varargin,'waitbar',[]);

	notify(o,'BeginValidation');
	    
	
	if(~isempty(o.kfolds))
        cvp = cvpartition(o.fileset.keys, 'kfold', o.kfolds);
	else
		cvp = cvpartition(o.fileset.keys);
	end
		
	o.results = BMResult(o.taxonomy.keys,o.fileset.keys,o.name);
	
	for i=1:cvp.NumTestSets
        idxtest = cvp.test(i);
        idxtrain = cvp.training(i);

		train = o.featureset.subset(idxtrain);
		test = o.featureset.subset(idxtest);
		
		% set observation names to the current taxonomy name
		obsnames = test.obsnames;
		test.obsnames = repmat({o.taxonomy.name},1,size(test.data,1));
		
		% do the hierarchical classification
		o.taxonomy.sweep(@(tax)classify(o,train,test,tax));
		
		% FIXME order can't contain duplicated values (ex
		% pizzicato.strings, sustained.strings)
        o.results.confusionmat(obsnames,test.obsnames,idxtest);
		if(~isempty(wb))
			wb = update(wb);
			drawnow();
		end
	end
    filltaxonomy(o.taxonomy,o.fileset,o.results.predictions);
	
	notify(o,'EndValidation');		
end

function filltaxonomy(tax,fs,predictions)
	if(isempty(tax.subclasses))
		return;
	end
	
	if(isempty(fs))
		keys = [];
		return;
	else
		keys = tax.namesoflevel(1,fs.keys);
	end
	
	tax.data.result = BMResult({tax.subclasses.name},keys,tax.name);
	
	preds = tax.namesoflevel(1,predictions);
	tax.data.result.confusionmat(keys,preds);
	
	for t=tax.subclasses
		idx = ismember(predictions,t.keys);
		idx = idx & ismember(fs.keys,t.keys)';
		filltaxonomy(t,fs.subset(idx),predictions(idx));
	end
end

function classify(o,train,test,tax)
	if(~haschilds(tax))
		return;
	end

	% keep only train data that exists in current taxonomy
	trn = train.subset(tax.keys);
	cint = tax.parsekeys(trn.obsnames);
	
	% keep only test data that has been predicted to be in the 
	% current taxonomy.
	tst = test.subset(tax.name);
	idx = strcmp(test.obsnames,tax.name);
	
	% get the data from the featureset, keeping only selected variables
	trn = trn.subset(:,tax.data.selection).data;
	tst = tst.subset(:,tax.data.selection).data;
	
	if(isempty(tst))
	else
		predictions = o.validationfunction(trn,cint(:,1),tst);
		ytest = {tax.subclasses.name};
		test.obsnames(idx) = ytest(predictions);
	end
	
end
