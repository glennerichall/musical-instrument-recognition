
function oo = clone(o)
	oo = Observation(o.ssize);
	oo.extractionfunction = o.extractionfunction;
	oo.parameters = o .parameters;
	oo.name = o.name;
	oo.stats = o.stats;
	oo.data = o.data;
    oo.variables = o.variables;
end