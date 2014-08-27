classdef Featureset < handle

	properties (Access = private)
		ssize = 0;
	end
	
	properties (SetObservable)
		obsnames = {};
		varnames = {};
		data = [];
	end
	
	methods
		function o = Featureset(varargin)
			[o.varnames, o.obsnames, o.data o.ssize] = ...
				process_options(varargin,'varnames',o.varnames,...
				'obsnames',o.obsnames,'data',o.data,'size',o.ssize);
			
			if(~isempty(o.data) && o.ssize>0)
				o.data = repmat(o.data,o.ssize,1);
			end
		end		

		
		function setObservation(o,i,obs)
			o.data(i,:) = obs;
		end
	
		o = normalize(o)
		oo = subset(o,idxobs,idxvars)
		varargout = subsref(o,s)
		[m n] = size(o,dim)
	end

end
