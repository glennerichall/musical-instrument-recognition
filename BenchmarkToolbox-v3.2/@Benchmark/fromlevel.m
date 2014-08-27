function o = fromlevel(o,l)
	o = o.clone();
	keys = o.taxonomy.namesoflevel(l,o.fileset.keys);
	o.fileset.setkeys(keys);
	o.taxonomy.trim(l+1);
end