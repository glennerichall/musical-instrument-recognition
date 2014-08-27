function o = clear(o)
%usage : o = clear(o) 
% clears the cache object o. Retains the file (on disk) associated with o.
%   where : 
%         o cache object (created with function cache())
%
% See also fetch, cache, commit, flush

% $Date: 2011-07-29 $
% $Author : Glenn-Eric Hall $
% $Revision : 1.1 $

    o.hits = 0;
    o.miss = 0;
    o.cache = [];
