% TODO comments
function o = select_scalar(o,varargin)

	notify(o,'BeginSelection');

    selection = process_options(varargin, 'selection', o.selection);  
    if(isempty(selection))
		if(iscell(o.featureset.data))
			s.selection = true(1,size(o.featureset.data{1},2));
			o.taxonomy.setdataall(s);			
		else
			s.selection = true(1,size(o.featureset.data,2));
			o.taxonomy.setdataall(s);
		end
		
    elseif(ischar(selection))
		[o.selection o.nfeatures] = getselection(selection);
        
        if(any(strcmp(selection,{'forward','backward'}))) % sequential selection
            o.taxonomy.sweep(@o.seqsel);

        elseif(strcmp(selection,'pca')) % principal component analysis
			s.selection = true(1,size(o.featureset.data,2));
			o.taxonomy.setdataall(s);
            [coeff, o.features] = princomp(o.features);
            if(~isempty(d))
                o.features = o.features(:,1:d);
            end
        end
    elseif(iscellstr(selection))
		s.selection = findfeatures(o,selection);
		o.taxonomy.setdataall(s);
        
    elseif(isnumeric(selection) || islogical(selection))
		s.selection = o.selection;
		o.taxonomy.setdataall(s);
    else
        error('MATLAB:paramAmbiguous', ...
            'selection values: [forward[n], backward[n], pca[n], column names or column indices, []');
    end


	notify(o,'EndSelection');	
end

% -------------------------------------------------------------------------
function inmodel = findfeatures(o,selection)
	if(isempty(o.featuresset.varnames))
		% TODO error
		error();
	end
	inmodel = false(1,size(o.features,2));
	for clse=selection
		im = true(1,size(o.features,2));
		if(iscell(clse))
			for j=1:length(clse)
				im = im & ~cellfun(@isempty, regexp(o.features.varnames,clse{j}));
			end
		else
			im = im & ~cellfun(@isempty, regexp(o.features.varnames,clse));
		end
		inmodel = inmodel | im;
	end  
end


% -------------------------------------------------------------------------
function [selection d] = getselection(selection)
	toks = regexp(selection,'(forward|backward|pca)(\[\d*\])?','tokens');
	d = [];
	if(~isempty(toks))
		selection = toks{1}{1};
		n = toks{1}{2};
		if(~isempty(n) && ~strcmpi(n,'[]'))
			d = str2num(n(2:end-1)); %#ok<ST2NM>
		end
	else
		% TODO error()
		error('benchmark:wrongargument',...
			'Selection values: [forward[n], backward[n], pca[n], column names or column indices');
	end
end
