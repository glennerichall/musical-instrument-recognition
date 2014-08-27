function o = copyfiles(o,dest)
	for i=1:length(o.files)
		[pathstr, name, ext] = fileparts(o.sfiles(i).file);	
		pathstr = strrep(pathstr,'\\','\');
		pathstr = strrep(pathstr,o.folder,dest);
		file = [pathstr, filesep, name, ext];
		% FIXME double backslashes
		if(~exist(pathstr,'dir'))
			mkdir(pathstr);
		end
		[status message messageid] = copyfile(o.sfiles(i).file,file,'f');
		if(~status)
			error(messageid, message);
		end
		o.sfiles(i).file = file;
		
	end
	o.folder = dest;
end