classdef Fileset < handle
	
	properties (Access = private)
		sfiles = [];		
	end
		
	properties (GetAccess = private)
		funkey = @(x) x;
		funinfo = @(x) x;	
	end
	
	properties (SetObservable)
		extension = [];	
		folder = [];
	end
	
	methods
		%------------------------------------------------------------------
		function o = Fileset(varargin)
			[o.folder o.extension o.funkey, o.funinfo, o.sfiles] = process_options(varargin,...
				'folder',o.folder,'extension',o.extension, ...
				'funkey',o.funkey,'funinfo',o.funinfo,'files',o.sfiles);
		end
		%------------------------------------------------------------------
		function oo = clone(o)		
			oo = Fileset('folder',o.folder,'extension',o.extension, ...
				'funkey',o.funkey,'funinfo',o.funinfo);
			oo.sfiles = o.sfiles;
		end
		%------------------------------------------------------------------
		function f = files(o)
			if(isempty(o.sfiles))
				f = [];
			else
				f = {o.sfiles.file};
			end
		end
		%------------------------------------------------------------------
		function oo = subset(o,idx)
			oo = Fileset();
			if(iscellstr(idx))
				idx = ismember(o.keys,idx);
			elseif(ischar(idx))
				idx = strcmp(o.keys,idx);
			end
			
			oo.sfiles = o.sfiles(idx(:));
		end
		%------------------------------------------------------------------
		function f = keys(o)
			if(~isempty(o.sfiles))
				f = {o.sfiles.key};
			else
				f = [];
			end
		end		
		%------------------------------------------------------------------
		function setkeys(o,keys)
			[o.sfiles.key] = deal(keys{:});
		end
	end
	
	events
	end
end



