%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @Author   : Glenn-Eric Hall
% @Date     : 2010-01-25
% @Revision : v1.0
% Logger based on log4j. 
% La journalisation se fait par rapport a un niveau de detail (de 0 a 4,
% {None, Info, Warn, Error, Debug} ). La journalisation s'effectue si la
% fonction appellee est <= niveau detail. Par exemple, une variable de type 
% Logger : logger = Logger() et logger.Warn(msg) est
% journalise si logger.Detail == Logger.Wrn || logger.Detail == Logger.Err || 
% logger.Detail == Logger.Dbg.
% La journalisation s'effectue par le biais d'un "appender", qui est ni
% plus ni moins qu'une "function handle" qui s'occupe d'ecrire le message
% dans un flot de sortie. Par exemple, un appender qui affiche a l'ecran :
% logger.Appenders = {@(x) disp(x)}. Si l'on desire specifier un detail de
% journalisation au niveau "appender", on utilise logger.Appenders de la facon
% suivante: logger.Appenders = {@disp, Logger.Wrn, @fileappender}.
% Finalement, un "appender" recoit une string en argument pour etre
% journalisee;  aucun argument passe a l'"appender" signifie d'ouvrir,
% fermer le flot de sortie.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef Logger < handle    
    properties (SetObservable = true)
        Detail;         % logging level
        ShowTime;       % log event date/time
    end
    
    properties (SetObservable = true, SetAccess = public, GetAccess = private)
        Appenders;      % logging appenders (writers). Appenders are 
                        % function handles and have 0 or 1 arguments. 
                        % 0 arguments indicates to open/close appender. 
                        % 1 argument indicates to log the string argument.
    end
    
    properties (Access = private)
       Loggers;
    end
        
    methods
        function o = Logger()    
            o.Loggers = [];
            o.ShowTime = true;
            o.Detail = LoggerDetail.getDefaultValue();
            
            addlistener(o,'Appenders','PostSet',...
                @(src,evnt) o.AppendersSet());
            
            addlistener(o,'Detail','PostSet',...
                @(src,evnt) o.DetailSet());       
            
            addlistener(o,'ShowTime','PostSet',...
                @(src,evnt) o.ShowTimeSet());    
            
            o.Loggers = {};
        end      
        function Warn(o, varargin)
            for i=1:length(o.Loggers)
                logger = o.Loggers{i};
                logger.Warn(varargin);
            end
        end
        
        function Error(o, varargin)
            for i=1:length(o.Loggers)
                logger = o.Loggers{i};
                logger.Error(varargin);
            end
        end
        
        function Debug(o, varargin)
            for i=1:length(o.Loggers)
                logger = o.Loggers{i};
                logger.Debug(varargin);
            end
        end   
        
        function Info(o, varargin)
            for i=1:length(o.Loggers)
                logger = o.Loggers{i};
                logger.Info(varargin);
            end
        end      
        
        function Exception(o, ME)
            stack = ME.stack;
            for i=1:length(o.Loggers)
                logger = o.Loggers{i};
                logger.Error('EXCEPTION  : ', ME.message);
                
                stbak = o.ShowTime;
                o.ShowTime = 0;
				N = length(stack);
                for i=1:N %#ok<FXSET>
                    logger.Error(stack(i).file);
                    logger.Error('		', stack(i).name, ':', stack(i).line);
                end
                o.ShowTime = stbak;
            end         
        end

    end
    
    methods (Access = private)  
        function ShowTimeSet(o)
             for i=1:length(o.Loggers)
                 o.Loggers{i}.ShowTime = o.ShowTime;
             end
        end
        function DetailSet(o)
             for i=1:length(o.Loggers)
                 o.Loggers{i}.Detail = o.Detail;
             end
        end
        function AppendersSet(o)
%             keys_ = {0, 1, 2, 3, 4};
%             values_ = cell(1,5);
%             M = containers.Map(keys_,values_);            
            n = length(o.Appenders);
            i = 1;
            while (i <= n)
                if(isa(o.Appenders{i},'function_handle'))
%                     c de la crotte ce code
%                     2011-03-1
%                     if(i < length(o.Appenders))
%                         if(isa(o.Appenders{i+1},'LoggerDetail'))
%                             arr = M(int32(o.Appenders{i+1}));
%                             arr{end+1} = o.Appenders{i}; %#ok<AGROW>
%                             M(int32(o.Appenders{i+1})) = arr;
%                         else
%                             arr = M(int32(o.Detail));
%                             arr{end+1} = o.Appenders{i}; %#ok<AGROW>
%                             M(int32(o.Detail)) = arr;
%                         end
%                     else
%                         arr = M(int32(o.Detail));
%                         arr{end+1} = o.Appenders{i}; %#ok<AGROW>
%                         M(int32(o.Detail)) = arr;
%                     end
                    o.Loggers{i} = LoggerBase();
                    o.Loggers{i}.Appenders = {o.Appenders{i}};
                    if(i<n) 
                        if(isa(o.Appenders{i+1},'LoggerDetail'))
                            o.Loggers{i}.Detail = o.Appenders{i+1};
                            i = i + 1;
                        end
                    end
                    i = i + 1;
                end
            end
%             keys_ = keys(M);
%             values_ = values(M);
%             
%             k = 1;
%             o.Loggers = {};
%             for i=1:length(keys_)
%                 if(~isempty( values_{i}))
%                     o.Loggers{k} = LoggerBase();
%                     o.Loggers{k}.Appenders =  values_{i};
%                     o.Loggers{k}.Detail = LoggerDetail(keys_{i});
%                     o.Loggers{k}.ShowTime = o.ShowTime;
%                     k = k+1;                
%                 end
%             end
        end
    end
end
