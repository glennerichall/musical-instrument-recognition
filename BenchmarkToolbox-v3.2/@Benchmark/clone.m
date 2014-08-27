function oo = clone(o)
% FIXME Calling STRUCT on an object prevents the object from hiding its
% implementation
	oo = Benchmark('name',o.name,'selection',o.selection,...
			'extractionfunction',o.extractionfunction,...
			'validationfunction',o.validationfunction,'kfolds',o.kfolds,...
			'backup',o.backup,'dontrunifexist',o.dontrunifexist,...
			'dosave',o.dosave,'verbose',o.verbose,...
			'randstream',o.randstream,'maxperclass',o.maxperclass);
		
	if(~isempty(o.taxonomy))
		oo.taxonomy = o.taxonomy.clone();
	end
	if(~isempty(o.fileset))
		oo.fileset = o.fileset.clone();
	end
	if(~isempty(o.featureset))
		oo.featureset = o.featureset.clone();
	end
	if(~isempty(o.results))
		oo.results = o.results.clone();
    end
    oo.varnames = o.varnames;
end