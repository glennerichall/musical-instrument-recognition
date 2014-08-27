
function oo = subset(o,idxobs,idxvars)
	oo = Featureset();

	if(nargin<3)
		if(~isempty(o.varnames))
			idxvars = true(1,length(o.varnames));
		else
			if(iscell(o.data))
				idxvars = true(1,size(o.data{1},2));
			else
				idxvars = true(1,size(o.data,2));
			end
		end
	end
	
	% get indices of observations
	if(iscellstr(idxobs))
		idxobs = ismember(o.obsnames,idxobs);
	elseif(ischar(idxobs))
		if(idxobs == ':')
			idxobs = true(1,size(o.data,1));
		else
			idxobs = strcmp(o.obsnames,idxobs);
		end
	end
	
	% get indices of variables
	if(iscellstr(idxvars))
		idxvars = ismember(o.varnames,idxvars);
	elseif(ischar(idxvars))
		idxvars = strcmp(o.varnames,idxvars);
	end	
	
	% select observations and variables and data
	if(~isempty(o.obsnames))
		oo.obsnames = o.obsnames(idxobs);
	end
	if(~isempty(o.varnames))
		oo.varnames = o.varnames(idxvars);
	end
	
	if(iscell(o.data))
		oo.data = o.data(idxobs,:);
		oo.data = cellfun(@(x) x(:,idxvars),oo.data,'uniformoutput',false);
	else
		oo.data = o.data(idxobs,idxvars);
	end
end