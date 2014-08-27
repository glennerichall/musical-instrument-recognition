function o = prepare_scalar(o)
	
	notify(o,'BeginPreparation');
	
	if(isempty(o.fileset))
		o.fileset.load();
	end
	if(isempty(o.taxonomy))
		if(~isempty(o.fileset))
			o.taxonomy = Taxonomy('None',unique(o.fileset.keys));
		else
			o.taxonomy = Taxonomy();
		end
	end
	
	o.results = BMResult(o.taxonomy.keys,o.fileset.keys,o.name);

    fkeys = o.fileset.keys;
    tkeys = o.taxonomy.keys;

	if(isempty(tkeys) || isempty(fkeys))
		return;
	end
    % regrouper les fichiers d'un meme instrument et ne selectionner que
    % <maxperclass> fichiers par classe (la derniere dans la
    % hierarchie). 
    s = o.randstream;
	idxs = [];
    for i=1:length(tkeys)
        idx = find(strcmp(fkeys,tkeys{i}));
        idx = idx(randperm(s,length(idx)));
        idx = idx(1:min(o.maxperclass,end));
        idxs = [idxs idx];
	end


    o.fileset = o.fileset.subset(idxs);
	if(~isempty(o.featureset))
		o.featureset = o.featureset.subset(idxs);
	end
	fkeys = o.fileset.keys;
	
	idx = ~ismember(tkeys,fkeys);

	o.taxonomy = o.taxonomy.remove(tkeys{idx});
	notify(o,'EndPreparation');
end