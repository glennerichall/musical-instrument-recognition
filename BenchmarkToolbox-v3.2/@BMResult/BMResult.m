classdef BMResult < handle
	properties (SetAccess = private)
		keys = {};
		name;
	end
	
	properties 
		confusion = [];
		errors = [];
		predictions = {};
	end
	
	properties (SetAccess = private)
		order = {};		
	end
	
	methods
		function o = BMResult(order,keys,name)
			if(nargin==0)
				return;
			end
			o.order = order;
			o.keys = keys;
			n = length(order);
			m = length(keys);
			o.confusion = zeros(n);
			o.predictions = cell(m,1);
			o.name = strrep(name,'/','-');
		end
		
		function mr = missrate(o)
			if(~isempty(o.confusion))	
				mr = 1-trace(o.confusion)/sum(o.confusion(:));
			else
				mr = [];
			end
			
			if(isnan(mr))
				mr=[];
			end
		end
		
		function oo = clone(o)
			oo = BMResult(o.order,o.keys,o.name);
			oo.confusion = o.confusion;
			oo.errors = o.errors;
			oo.predictions = o.predictions;
		end
		
		function o = confusionmat(o,known,predictions,idx)
			o.confusion = o.confusion + confusionmat(known,predictions,...
			'order',o.order);
		
			if(nargin==3)
				idx=true(1,length(known));
			end
			o.predictions(idx) = predictions;
			o.errors(idx) = ~strcmp(known,predictions);
		end
		
		function hr = hitrate(o)
			hr = 1-o.missrate();
        end
        
        function plotxls(o,varargin)
            conf = o.confusion;
            order = o.order;
            filename = process_options(varargin,'dir','c:\temp\');
            filename = [filename o.name '.xlsm'];
            plot_confusion(conf,order,filename);
        end
        
        function o = removekeys(o,varargin)
            tkeys = varargin;
            
            idx = ~ismember(o.keys,tkeys);
            o.keys = o.keys(idx);
            
            idx = ~ismember(o.predictions,tkeys);
            o.predictions = o.predictions(idx);
            
            idx = ~ismember(o.order,tkeys);
            o.order = o.order(idx);
            
            o.confusion = o.confusion(idx,idx);
        end
        
        function o = groupkeys(o,newkey,varargin)
            tkeys = varargin;
            
            idx = ismember(o.keys,tkeys);
            [o.keys{idx}] = deal(newkey);
            
            idx = ismember(o.predictions,tkeys);
            [o.predictions{idx}] = deal(newkey);
            
            idx = ismember(o.order,tkeys);
            [o.order{idx}] = deal(newkey);
            nl = min(find(idx));
            idx2 = ~idx;
            idx2(nl) = true;
            o.order = o.order(idx2);
            
            
            o.confusion(:,nl) = sum(o.confusion(:,idx),2);
            o.confusion(nl,:) = sum(o.confusion(idx,:),1);
            o.confusion = o.confusion(idx2,idx2);
            
        end
        
		h = plot(o,varargin)

	end
end