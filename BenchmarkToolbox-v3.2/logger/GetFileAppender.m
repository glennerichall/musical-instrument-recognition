function handle = GetFileAppender(fileName)


    obj.fileName = fileName;
    obj.isOpened = 0;
    obj.fileHandle = [];
    
    function f(x)
        if(nargin == 0)
            if(obj.isOpened)
                fclose(obj.fileHandle);
                obj.isOpened = 0;
            end
        else
            if(~obj.isOpened)				
                obj.fileHandle = createnew(obj.fileName);
                obj.isOpened = 1;
            end
            if(~strcmp(fopen(obj.fileHandle),''))
				s = dir(obj.fileName);
				if(s.bytes>1e6)
					fclose(obj.fileHandle);
					obj.fileHandle = createnew(obj.fileName);
				end
                fwrite(obj.fileHandle, x);
                fwrite(obj.fileHandle, char(10));
			else
				obj.fileHandle = createnew(obj.fileName);
				f(x);
            end
        end
    end

    handle = @f;
end

function fhandle= createnew(filename)
	bakup_file(filename);
	fhandle = fopen(filename, 'wt');
end