function o = extract_scalar(o)
	notify(o,'BeginExtraction');
	ismultithread = matlabpool('size')>0;
    
    if(isempty(o.fileset.files))
        error('please run prepare.m');
    end

    files = o.fileset.files;
    m = length(files);
	if(o.verbose)
        % TODO parrallel logic
        
        if(~ismultithread)
            wb = Waitbargh(m, 'message', 'Extracting Features','isgraphic',true,...
                'time-interval',0,'pourcent-interval',0);
        else      
            ppm = ParforProgMon('Extracting', m);
        end
	end 
	o.featureset = [];
	
% PARALLEL
    if(ismultithread)
            % TODO parrallel logic
            % TODO cache enabled parallel parfor
        features = {};
        extractionfunction = o.extractionfunction;

    %     tic;
        parfor i=1:length(files)
            try
                file = files{i};
                features{i} = extractionfunction(file);
    %             wb.update();
                ppm.increment();
    %             drawnow();
    %              toc;
            catch ME
                disp (files{i});
                rethrow (ME);
            end
        end
        if(all(cellfun(@(x)size(x,1)==1,features)))
            features = cell2mat(features');
        end
        o.featureset = Featureset('data',features,'obsnames',o.fileset.keys);
% END PARALLEL    
    else
% NO PARALLEL
        for i=1:length(files)
            try
                obs = o.extractionfunction(files{i});
            catch ME
                disp (files{i});
                rethrow (ME);
            end

            if(size(obs,1)>1)
                obs = {obs};
            end
            if(isempty(o.featureset))
    % 			TODO use dataset class or derive Featureset from dataset
                o.featureset = Featureset('data',obs,...
                    'obsnames',o.fileset.keys,'size',m);
            end
            % TODO same as above
            o.featureset.setObservation(i,obs);

            if(o.verbose)
                wb = update(wb);
            end
        end
    end
% END NO PARALLEL
	o.featureset.normalize();
	notify(o,'EndExtraction');
end