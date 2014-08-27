classdef(Enumeration) LoggerDetail < int32
    enumeration
        % ---- logging level -----------
        Debug(4);    % Debug        level 4
        Error(3);    % Error        level 3
        Warn(2);     % Warning      level 2
        Info(1);     % Info         level 1
        None(0);     % No logging   level 0
    end
    
    methods (Static = true)
        function retVal = getDefaultValue()
            retVal = LoggerDetail.Debug;
        end
    end
end