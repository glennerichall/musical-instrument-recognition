function [o, varargout] = fetch(o, fun, varargin)
%usage : fetch(o, fun, funparam1, funparam2, ...) 
%   where : 
%           o cache object (created with function cache())
%           fun function handle
%           funparam1, funparam2, ... function fun parameters
% fetch returns a new cache object o and variable output arguments
% depending on fun output arguments
%
% See also cache, clear, commit, flush

% $Date: 2011-07-29 $
% $Author : Glenn-Eric Hall $
% $Revision : 1.1 $

% TODO autocommit
    hash = @(f, p) [to_string(f) to_string(p)];
    [hash params] = process_options(varargin,'hash',hash);

    % retreive from database or call function and save into databse
    if ~isempty(o.cache)
        h = hash(fun,params);
        date = getFunDate(fun);
        
        if(o.cache.isKey(h))
            A = o.cache(h);
            if(A.date < date)
                o.cache.remove(h);
            end
        end
        
        % the function has already been called with current parameters
        if(o.cache.isKey(h));
            A = o.cache(h);
            A = A.data;
            o.hits = o.hits + 1;
            
        % call the function with current parameters and save into database
        else
            clear A;
            if(nargout(fun)==1)
                A.data = fun(params{:});
            elseif(nargout(fun)>0)
                [A.data{1:nargout(fun)}] = fun(params{:});
            else
                [A.data{1:nargout-1}] = fun(params{:});
            end
            A.date = date;
            o.cache(h) = A;
            o.miss = o.miss + 1;
            A = A.data;
        end
    elseif(exist(o.file,'file'))
        cache = load(o.file, 'cache');
        o.cache = cache.cache;
        clear cache;
        [o, varargout] = fetch(o, fun, varargin{:});
        return;
    else
        o = cache(o.file);
        [o, varargout] = fetch(o, fun, varargin{:});
        return;
    end
    
    if(iscell(A))
        [varargout{1:nargout-1}] = deal(A{1:nargout-1});
    else
        varargout = {};
        varargout{1} = A;
    end
    
    
end