function options = GetLogger(options)
    if(isfield(options,'log'))
        if(isempty(options.log))
            if(isfield(options,'log_file'))
                options.log = GetDefaultLogger(options.log_file);
            else
                options.log = GetDefaultLogger();
            end
            
            if(isfield(options, 'log_details'))
                options.log.Detail = options.log_details;
            end
        end

        options.log.Warn('-------------------------------------------------');
        options.log.Warn('Processing options');
        options.log.Warn(options);
        options.log.Warn('-------------------------------------------------');
    end  
end