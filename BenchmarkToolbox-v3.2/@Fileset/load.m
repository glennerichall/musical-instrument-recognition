function [o cche] = load(o, varargin)
 
	[o.folder o.extension, cche] = process_options(varargin,...
		'folder',o.folder,'extension',o.extension, 'cache',[]);

	if(~isempty(cche))

		if(ischar(cche))
			cche = cache(cche);
		elseif(~isa(cche,'cache'))
			% TODO error
			error();
		else
			if(nargout==1)
				% TODO error
				error();
			end
		end
	end

	if(~isempty(cche))
		[cche o.sfiles] = fetch(cche,@get_files,o,o.folder,o.extension);
		cche = commit(cche);
	else
		o.sfiles = get_files(o,o.folder,o.extension);
	end

	if(isempty(o.sfiles))
		% TODO error
% 		error('No files loaded',o.folder,o.extension);
	end
end