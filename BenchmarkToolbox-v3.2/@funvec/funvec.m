function o = funvec(varargin)
% TODO comments
    o = struct();
    o.flist(1).parameters = {};
	o.flist(1).outputs = {};
	o.flist(1).function = [];
	o.catresult = false;
	
    if(isempty(varargin))
        o = class(o,'funvec');
        return;
    end
    
	
	

    fidx = cellfun(@(x)isa(x,'function_handle'),varargin);
	
	% TODO generalize to all group of functions
	% ie funvec(f1,f2,'catresults',f3,f4,'catresults') would cat 
	% results of f1 and f2 and results of f3,f4
	if(strcmpi(varargin{end},'catresult'))
		o.catresult = true;
	end

    % map new functions with arguments to functions passed in varargin
	i=1;
    for m=find(fidx)
		if(m>1 && iscell(varargin{m-1}))
            params = varargin{m-1};
		else
			params = {};
		end
		if(m<length(varargin) && isnumeric(varargin{m+1}))
            outputs = varargin{m+1};
		else
			outputs = [];
		end
		o.flist(i).function = varargin{m};
		o.flist(i).parameters = params;
		o.flist(i).outputs = outputs;
		
		i=i+1;
	end
	
	% normalize function list
	for i=1:length(o.flist)
		if(isempty(o.flist(i).outputs))
			nout = max(nargout(o.flist(i).function),1);
			o.flist(i).outputs = 1:nout;
		end
	end
	
	o = class(o,'funvec');
end