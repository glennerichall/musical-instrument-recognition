
function o = run_scalar(o,varargin)
	folder = process_options(varargin,'save-folder','c:\temp\scenarios\');
	dontrunifexist = any(strcmpi(varargin,'dontrunifexist'));
	filename = [folder o.name '.mat'];
	if((o.dontrunifexist || dontrunifexist) && exist(filename,'file'))
		o = benchmark(filename);
		return;
	end
	
    if(o.verbose)
        disp(['Running Benchmark ' o.name]);
    end
    
    if(o.verbose)
        disp ('Fileset Preparation');
    end
    o = prepare(o);
    
    if(o.verbose)
        disp('Feature Extraction');
    end    
    o = o.extract();
    
    if(o.verbose)
        disp('Feature Selection');
    end       
    o = select(o,varargin{:});
    
    if(o.verbose)
        disp('Cross Validation');
    end  
    o = validate(o);
    
    %% save workspace
    if(o.dosave)
        if(o.verbose)
            disp('Saving Benchmark');
        end          
        
        filename = [folder o.name '.mat'];
		if(o.backup)
			bakup_file(filename);
		end
        if(~exist(folder,'dir'))
            mkdir(folder);
        end
        o.savebm(filename);
    end    
end
