classdef Observation < handle

	properties (Dependent = true)
		varnames = {};
	end
	
	properties (Access=private)
		variables = {};
	end
	
	properties (SetObservable)
		extractionfunction = @error;
		parameters = {};
		name = [];
		stats =  {@mean};
		data = [];
		ssize=[];
        cache=[];
	end
	
	methods (Access = private)

	end
	
% 	methods (Static)
% 		function o = cache(c)
% 			persistent cache_;
% 			if(nargin==1 && ~isempty(c) && isa(c,'cache'))
% 				cache_ = c;
% 			end
% 			o = cache_;
% 		end
% 	end
	
	methods
		function o = Observation(ssize,cache)
			o.ssize = ssize;
            if(nargin==2)
                o.cache=cache;
            end
		end		
		
		function vn = get.varnames(o)
			if(~iscellstr(o.variables))
				vn = arrayfun(@(x) [o.name '.' o.variables '-' num2str(x,'%02d')],1:o.ssize, ...
					'UniformOutput',false);
			else
				vn = strcat(o.name, '.', o.variables);
			end				
		end
		
		function set.varnames(o,vn)
			o.variables=vn;
        end
		
        function oo = saveobj(o)
            oo = o.clone();
            oo.cache = [];
        end
        
		out = extract(o,file)
		oo = clone(o)
	end
	
	
	events
	end
end

