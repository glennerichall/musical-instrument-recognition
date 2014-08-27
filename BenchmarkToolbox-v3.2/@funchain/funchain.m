function o = funchain(varargin)
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

	o = struct();
	
	o.flist(1).parameters = {};
	o.flist(1).outputs = {};
	o.flist(1).function = [];
	
    fidx = cellfun(@(x)isa(x,'function_handle'),varargin);

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
	for i=1:length(o.flist)-1
		if(isempty(o.flist(i).outputs))
			nout = abs(nargout(o.flist(i).function));
			nin = nargin(o.flist(i+1).function);
			if(nin<0) % variable input
				o.flist(i).outputs = 1:nout;
			else
				o.flist(i).outputs = 1:min(nout,nin);
			end
		end
	end
	
	o = class(o,'funchain');
end