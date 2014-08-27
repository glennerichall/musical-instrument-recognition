function o = filter(o,varargin)
	for i=1:2:length(varargin)
		tmp = o.sfiles;
        fields = strsplit(varargin{i},'.');
        field = fields{end};
			for j=1:length(fields)-1
				tmp = [tmp.(fields{j})];
			end
        keep = true;
        if(field(1)=='~')
            field = field(2:end);
            keep = false;
        end
        values = varargin{i+1};
        
        if(iscellstr(values))
            idx = ismember({tmp.(field)}, values);
            if(~keep)
                idx = ~idx;
            end
        elseif(ischar(values))
            if(values(1)=='>')
                if(values(2)=='=')
                    idx = [tmp.(field)] >= str2num(values(3:end));
                else
                    idx = [tmp.(field)] > str2num(values(2:end));
                end
            elseif(values(1)=='<')
                if(values(2)=='=')
                    idx = [tmp.(field)] <= str2num(values(3:end));
                else
                    idx = [tmp.(field)] < str2num(values(2:end));
                end
            else
                idx = [tmp.(field)] == values;
            end
        end
        o.sfiles = o.sfiles( idx );
	end
end