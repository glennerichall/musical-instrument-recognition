function oo = clone(o)
	oo = Featureset();
	oo.obsnames = o.obsnames;
	oo.varnames = o.varnames;
	oo.data = o.data;
	oo.ssize = o.ssize;
end