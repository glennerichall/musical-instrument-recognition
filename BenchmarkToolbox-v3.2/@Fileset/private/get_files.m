% get recursively the filenames

%--------------------------------------------------------------------------
function files = get_files(o,directory, exte)  
	files = [];
	if(isempty(directory))
		return;
	end;
    files = struct('file',[],'length',[],'key',[],'info',[]);
    
    if(nargin == 0) %#ok<ALIGN>
       directory = cd;
	end
	    
    Fx = strcat(directory, '\.');
    Fxx = strcat(directory, '\..');
    

    Files_ = dir(directory);
    for i=1:length(Files_)
        F = Files_(i);
        FName = strcat(directory, '\', F.name);
        if(F.isdir)
            if(~strcmp(Fx,FName) && ~strcmp(Fxx,FName))
                Fz = get_files(o, FName, exte);
                
                if(isempty(files(1).file))
                    files(1:length(Fz)) = Fz;
                else
                    files(end+1:end+length(Fz)) = Fz;
                end
                 
            end
		else 
			
            [pathstr, name, ext] = fileparts(FName);
            if(strcmpi(ext, exte) || isempty(exte) || strcmpi(ext, '.*'))
                if(isempty(files(1).file))
                    files(end) = getInfo(o,FName);
                else
                    files(end+1) = getInfo(o,FName); %#ok<AGROW>
                end
                
            end
        end
    end
    
    if(length(files)==1 && isempty(files(1).file))
        files = [];
    end
end


%--------------------------------------------------------------------------
function s = getInfo(o,FName)
    siz = wavread(FName,'size')*[1;0];

    s.file = FName;
    s.length = siz;
    s.key =  o.funkey(FName);
    s.info = o.funinfo(FName);
end