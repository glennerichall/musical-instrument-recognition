classdef Taxonomy < handle
	
	properties (SetAccess = private)
		childs = {};
		parent;
	end
	properties (SetAccess = private)
		name = {};
	end
	properties (SetObservable)
		data;
	end
	
	methods 
		%------------------------------------------------------------------
		function o = Taxonomy(name,varargin)
			if(nargin==0)
				return;
			end

			o.name = name;
			
			if(isempty(varargin))
				return;
			elseif(length(varargin)==1 && iscell(varargin{1}))
				for i=1:length(varargin{1})
					o.childs{i} = Taxonomy(varargin{1}{i});
				end
				return;
			end
			
			k=1;
			for i=1:2:length(varargin)
				[tax(k).name tax(k).childs] = strtok(varargin{i},'.');
				tax(k).childs = tax(k).childs(2:end);
				tax(k).keys = varargin{i+1};
				k=k+1;
			end
			names = unique({tax.name});
			
			
			k=1;
			for i=1:length(names)
				if(isempty(names{i}))
					idx = strcmp({tax.name},names{i});
					t = tax(idx);
					keys = {t.keys{:}};
					for j=1:length(keys)
						o.childs{k} = Taxonomy(keys{j});
						o.childs{k}.parent = o;
						k=k+1;
					end
				else
					idx = strcmp({tax.name},names{i});
					t = tax(idx);
					t = interleave({t.childs},{t.keys});
					% FIXME funcking matalb class arrays doesnt work fuck. see
					% depth method				
					o.childs{k} = Taxonomy(names{i},t{:});
					o.childs{k}.parent = o;
					k=k+1;
				end
			end
			
        end
        %------------------------------------------------------------------
        function node = findnode(o,nodename)
            node = o;
            while(~isempty(node) && ~any(strcmp({node.name},nodename)))
                node = node.subclasses;
            end
            if(~isempty(node))
                idx = strcmp({node.name},nodename);
                node = node(idx);
            else
                node = [];
            end
        end
        %------------------------------------------------------------------
		function o = head(o)
			while(~isempty(o.parent))
				o = o.parent;
			end
		end
		%------------------------------------------------------------------		
		out = subclasses(o,varargin)
		k = keys(o)
		% TODO Changed notification
		o = crop(o,l1,l2)
		o = trim(o,l)
		p = path(o)
		out = pathto(o,varargin)
		cint = parsekeys(o,keys)
		keys = namesoflevel(o,l,varargin)
		o = level(o,l,varargin)
		d = depth(o)
		display(o)	
		sweep(o,fun,post)
		% TODO Changed notification
		setdataall(o,data)	
		out = clone(o)
		% TODO Changed notification
		out = removenode(o,path)
	end
	
	methods (Access = private)
		function notifyhead(o,evt)
			notify(o.head(),evt);
		end
	end
	
	events
		Changed;
	end
end