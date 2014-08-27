function L = GetDefaultLogger(log_file, log_file_details)
%     SI = dbstack();
%     caller = SI(2).name;
    L = Logger();
    L.Detail = LoggerDetail.None;
    
    if(nargin >= 1)
        if(nargin >= 2)
            L.Appenders = {@disp, GetFileAppender(log_file), log_file_details};
        else
            L.Appenders = {@disp, GetFileAppender(log_file)};
        end
    else
         L.Appenders = {@disp};
    end
    % ---------------------------------------------------------------------
end
