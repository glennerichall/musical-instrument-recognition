function o = flush(o)
%usage : o = flush(o) 
% clears the cache object o. Deletes the file (on disk) associated with o.
%   where : 
%         o cache object (created with function cache())
%
% See also fetch, cache, commit, clear

% $Date: 2011-07-29 $
% $Author : Glenn-Eric Hall $
% $Revision : 1.0 $

    o.hits = 0;
    o.miss = 0;
    if(exist(o.file,'file'))
        delete(o.file);
    end
       