classdef Cache < handle
    
    properties (Access = private)
        cache;
        file;
        hits;
        miss;
        hits2commit;
    end
    
    methods
        function o = Cache(file,varargin)
            %usage : o = cache(file) 
            %   where : 
            %           file is the destination of the cache file (a .mat file)
            %
            % See also fetch, clear, commit, flush

            % $Date: 2011-07-29 $
            % $Author : Glenn-Eric Hall $
            % $Revision : 1.1 $


            if(isa(file,'cache'))
                o = file;
                return;
            end

            % load or create and save database
            if(exist(file,'file'))
                cache = load(file, 'cache');
                o.cache = cache.cache;
                clear cache;
                o.file = file;
                o.hits = 0;
                o.miss = 0;
                o.hits2commit = 200;
            else
                pathstr = fileparts(file);
                if(~exist(pathstr,'dir'))
                    mkdir(pathstr);
                end
                cache = containers.Map;       
                save(file, 'cache');
                o.cache = cache;
                clear cache;
                o.file = file; 
                o.hits = 0;
                o.miss = 0;
                o.hits2commit = 200;
            end

        end
        clean(o,varargin)
        o = clear(o)
        o = commit(o)
        display(o)
        [o, varargout] = fetch(o, fun, varargin)
        o = flush(o)
        b = loadobj(a)
        push(o, fun, params, val)
    end
end




    
    
  