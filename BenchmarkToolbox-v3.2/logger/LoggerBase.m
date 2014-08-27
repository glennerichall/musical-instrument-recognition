%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @Author   : Glenn-Eric Hall
% @Date     : 2010-01-25
% @Revision : v1.0
% Logger based on log4j. 
% La journalisation se fait par rapport a un niveau de detail (de 0 a 4,
% {None, Info, Warn, Error, Debug} ). La journalisation s'effectue si la
% fonction appellee est <= niveau detail. Par exemple, une variable de type 
% Logger : logger = Logger() et logger.Warn(msg) est
% journalise si logger.Detail == LoggerDetail.Warn || logger.Detail == LoggerDetail.Error || 
% logger.Detail == LoggerDetail.Debug.
% La journalisation s'effectue par le biais d'un "appender", qui est ni
% plus ni moins qu'une "function handle" qui s'occupe d'ecrire le message
% dans un flot de sortie. Par exemple, un appender qui affiche a l'ecran :
% logger.Appenders = {@(x) disp(x)}.
% Finalement, un "appender" recoit une string en argument pour etre
% journalisee;  aucun argument passe a l'"appender" signifie d'ouvrir,
% fermer le flot de sortie.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef LoggerBase < handle
        
    properties (Access = private)
        Namespace;
        IsOpened;
     end
    
    properties
        Detail;         % logging level
        Appenders;      % logging appenders (writers). Appenders are 
                        % function handles and have 0 or 1 arguments. 
                        % 0 arguments indicates to open/close appender. 
                        % 1 argument indicates to log the string argument.
        ShowTime;       % log event date/time
    end
    
    methods
        function o = LoggerBase()
%             o.Namespace = NS;
            o.IsOpened = false;
            o.ShowTime = true;             
        end
        
        function Warn(o, varargin)
            if(o.Detail >= LoggerDetail.Warn)
                o.Log(varargin);
            end
        end
        
        function Error(o, varargin)
            if(o.Detail >= LoggerDetail.Error)
                o.Log(varargin);
            end
        end
        
        function Debug(o, varargin)
            if(o.Detail >= LoggerDetail.Debug)
                o.Log(varargin);
            end
        end   
        
        function Info(o, varargin)
            if(o.Detail >= LoggerDetail.Info)
                o.Log(varargin);
            end
        end
        
    end
    
    methods (Access = private)

    end
    
    methods (Access = protected)
        %----------------------------------------------------------------
        % Format the message variable to string.
        %----------------------------------------------------------------        
        function str = ToString(o, c)
            if(~iscell(c))
                x = c;
                if(isnumeric(x) || islogical(x))
%                     if(length(x) == 1)
                        str = num2str(x);
%                     else
%                         str = MatToString(x);
%                     end
                elseif(ischar(x))
                    str = x;
                % TODO format a struct.
                elseif(isstruct(x))
                    str = '[struct]';
                % TODO the rest of the variable types
                else
                    str = '[unknown]';
                end
            % message is a cell, format and concat each element of the cell
            else
                str = cellfun(@o.ToString, c, 'UniformOutput', false);
                str = strcat(cell2mat(str));
%                 str = [];
%                 for i=1:length(str_)
%                     str = strcat([str char(10) str_{i}]);
%                 end
%                 str = strtrim(str); 
            end
          
            
        end
        
        %----------------------------------------------------------------
        % Log every field of a struct.
        %----------------------------------------------------------------       
        function LogStruct(o, s)
            flds = fields(s);
            
            function res = f(x)
                y = eval(strcat('s.',x));
                %TODO class for everything
                if(isstruct(y))
                    res = strcat([x ' : [1x1 struct]']);
                elseif(isa(y,'handle'))
                    res = strcat([x ' : handle']);
                else
                    if(isempty(y))
                        str = '[empty]';
                    elseif(isobject(y))
                        str = class(y);
                    elseif (isnumeric(y) || islogical(y))
                        if(length(y) == 1)
                            str = num2str(y);
                        else
                            str = class(y);
                        end
                    elseif(ischar(y))
                        str = y;
                    else
                        str = '[unknown]';
                    end
                    res = strcat([x ' : ' str]);
                end               
            end
            
            strs = cellfun(@f, flds, 'UniformOutput', false);
            
            cellfun(@o.Log, strs);
        end
        
        %----------------------------------------------------------------
        % Log a variable.
        %----------------------------------------------------------------
        function Log(o, msg)            
            if(iscell(msg))
                while(length(msg) == 1 && iscell(msg{1}))
                    msg = msg{1};
                end
                if(length(msg{1}) == 1 && isstruct(msg{1}))
                    o.LogStruct(msg{1});
                else
                    if(size(msg{1},1)==1)
                        o.Log(o.ToString(msg));
                    else
                        for i=1:size(msg{1},1)
                            a=num2str(msg{1});
                            o.Log(o.ToString(a(i,:)));
                        end
                    end
                end
                return;
            end
            
            % if the logger is not already openend, open all appenders.
            % the appenders are openend by calling the functin handle
            % without any arguments.
%             if(~o.IsOpened)
%                 for i=1:length(o.Appenders)
%                     fun = o.Appenders{i};
%                     try
%                         fun();
%                     catch me
%                     end
% 				end    
% 				
				% TODO isOpened pour un seul appender, envoyer message
% 				% egalement si non reussi 2010-02-19
%                 o.IsOpened = true;
%             end
        
            for i=1:length(o.Appenders)
                fun = o.Appenders{i};
                if(o.ShowTime)
                   fun([datestr(now) '   ' msg]);
                else
                    fun(msg);
                end
            end
		end
        
		%TODO trouver un moyen de fermer le fichier a la fin du programme.
        % utiliser nargin(fun)
        function delete(o)
            for i=1:length(o.Appenders)
                fun = o.Appenders{i};
                try
                    fun();
                    o.isOpened = false;
                catch me
                end
            end            
        end
    end
end
