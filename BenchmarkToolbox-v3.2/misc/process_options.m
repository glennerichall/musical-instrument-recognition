function varargout = process_options(args, varargin)
% TODO comments

    if(iscell(args) && isstruct(varargin{1}))
        if(~isempty(args))
            if(~isstruct(args{1}) )
                args = cell2struct(args(2:2:end),args(1:2:end),2);
            else
                args=args{1};
            end
        else
            args=struct();
        end
    end
        
    if(isstruct(args) && isstruct(varargin{1}))
        src = varargin{1};
        dst = args;
        
        % ne garder que les champs de la source
        afields = fieldnames(dst);
        idx = ~ismember(afields, fieldnames(src));
        dst = rmfield(dst, afields(idx));

        % copier les champs de la source vers la distination s'il n'existe
        % pas deja
        afields = fieldnames(src);
        for i=1:length(afields)
            if(~isfield(dst, afields{i}))
				if(length(dst)>1)
					[dst.(afields{i})] = deal(src.(afields{i}));
				else
					dst.(afields{i}) = src.(afields{i});
				end
            end
        end
        
        varargout{1} = dst;           
	else
		
		if(length(args)==1 && isstruct(args{1}))
			args = interleave(fieldnames(args{1}),struct2cell(args{1}));
		end
		
        varargout = cell(1,nargout);
        m = length(varargin);
        idxs = zeros(1,length(args));
        for i=0:2:m-2
            arg = varargin{i+1};        
            idx = strcmpi(args, arg);
            if(~any(idx))
                varargout{i/2+1} = varargin{i+2};
            else
                j = find(idx)+1;
                varargout{i/2+1} = args{j};
                idx(j) = true;
            end

            if(~isempty(idxs) && ~isempty(idx))
                idxs = idxs | idx;
            end
        end

        if(nargout == m/2+1)
            varargout{end} = args(~idxs);
        end
    end
end