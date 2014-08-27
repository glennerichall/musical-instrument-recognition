function fun = funchain(varargin)
% create function composition from list of functions
% ex:
% f = @(x) x^2;
% g =  @(y) y+10;
% func = funchain(f,g);
% z = func(2)
% z = 
%     22
% is the same as writing
% z = g(f(2))
% function calling parameters:
% func = funchain(@(x) x^2, @(x,y) x+y);
% z = func(2,'fargs[2]',4)
% z = 
%     8
% sends parameters after fargs[i] to ith function in list
% f = funchain(f1,f2,...,fn)
%     f(param_1.1,param_1.2,'fargs[i]',param_i.1, param_i.2, 'fargs[j]' param_j_1,...);
% funchain(f1,f2,[2 3],f3)
% sends all outputs of f1 to f2 inputs, sends outputs 2 and 3 of f2 to
% intputs 1 and 2 of f3

% f=funchain({'y','z'},@(a,x,y,z)deal(a,x,y,z),[1 2],{'x','y','t'},@(a,x,y,z,t) [a x y z t])
% does not work f('x','y') because of deal

	flist = varargin;
    fidx = cellfun('isclass',flist,'function_handle');
    
    % map new functions with arguments to functions passed in varargin
    for m=find(fidx)-1
        if(m>0 && iscell(flist{m}))
            flist{m+1} = @(varargin) flist{m+1}(varargin{:},flist{m}{:});
            flist{m} = [];
        end
    end
    
    %create function composition
	function varargout = f(varargin)
        
        % find fargs[i] options
        strs = find(cellfun(@ischar,varargin));
        toks = regexp(varargin(strs),'fargs\[(\d*)\]','tokens');
        
        % find functino number of fargs options
        toksidx = ~cellfun(@isempty,toks);
        argsidx = strs(toksidx);
        
        % find functions
        funcs = cellfun(@(x) str2num(x{1}{1}),toks(toksidx));
        
        % create fargs arguments to individual functions
        [args{1:sum(fidx)}] = deal({});    
        if(~isempty(argsidx))
            args{1} = varargin(1:argsidx(1)-1);
        else
            args{1} = varargin;
        end
        
        n=length(argsidx);
        for i=1:n
            j = funcs(i);
            if(i==n)
                k = length(varargin);
            else
                k = argsidx(i+1)-1;
            end
            args{j} = varargin(argsidx(i)+1:k);
        end
        
        varargout = {}; 
        
        % do the function composition by chaining outputs to inputs
        j=1;
		for i=find(fidx)
			varargin = varargout;
			f = flist{i};
			
            % only select some of outputs
            if(i<length(flist) && isnumeric(flist{i+1}))
                nout = nargout(f);
                if(nout<=0)
                    nout = max(flist{i+1});
                end
                [varargout{1:nout}] = f(varargin{:},args{j}{:});
                varargout = varargout(flist{i+1});
            else
                
                nout = nargout(f);
                
                % output of f is not variable
                if(nout>0)
                    varargout = cell(1,nout);
                    [varargout{:}] = f(varargin{:},args{j}{:});
                    
                % not the last function in chain, and number of outputs of
                % f is variable
                elseif(i<length(flist))
                    % then check the number of inputs of next function in
                    % chain
                    nin = nargin(flist{i+1});
                    
                    % if it is also variable, then suppose there is only
                    % one output variable of current function f
                    if(nin<0)
                        nin=length(args{j+1})+1;
                    end
                    varargout = cell(1,nin-length(args{j+1}));
                    [varargout{:}] = f(varargin{:},args{j}{:});
                    
                 % last function in chain ??????
                elseif(i==length(flist))
                    if(nargout>0)
                        varargout = cell(1,nargout);
                        [varargout{:}] = f(varargin{:},args{j}{:});
                    else
                        varargout = f(varargin{:},args{j}{:});
                    end
                
                % last function in chain ?????
                else
                    varargout = f(varargin{:},args{j}{:});
                end
            end
            j=j+1;
		end
		if(~iscell(varargout))
			varargout = {varargout};
		end
	end
	
	fun = @f;
end