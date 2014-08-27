function o = commit(o)
%usage : o = clear(o) 
% commits (saves) the data contained in o on disk
%   where : 
%         o cache object (created with function cache())
%
% See also fetch, clear, cache, flush

% $Date: 2011-07-29 $
% $Author : Glenn-Eric Hall $
% $Revision : 1.0 $

    if(o.miss >= 1)
        if(~exist(o.file,'file')) % create file
            pathstr = fileparts(o.file);
            if(~exist(pathstr,'dir'))
                mkdir(pathstr);
            end
        else % add elements inserted in cache file outside of current object 
            cache = load(o.file,'cache');
            cache = cache.cache;
            keys = cache.keys;
            hasNotKeys = ~isKey(o.cache, keys);
            
            if(any(hasNotKeys))
                values = cache.values;
                for i=find(hasNotKeys)
                    o.cache(keys{i}) = values(i);
                end
            end
        end
        cache = o.cache; %#ok<NASGU>
        save(o.file, 'cache');
        o.hits = 0;
        o.miss = 0;
    end 
