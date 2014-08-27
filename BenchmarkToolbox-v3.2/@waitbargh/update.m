function [o, varargout] = update(o,varargin)
    % TODO comments
    o.i = o.i+1;

    message = process_options(varargin,'message',o.message);
    time=toc(o.delta);
    o.time(o.i) = time;
    if(mod(o.i,10)==0)   
        o.j = o.j+1;
        mea = mean(o.time(1:o.i));
        idx = o.time>mea/2;
        mea = mean(o.time(idx));
        m = round(mea*(o.n-o.i));
        o.estfit(o.j) = m;
        idx(1)=false;
        x = 1:o.n;
        estfit = (o.n - x(idx)) .* o.time(idx);
        
        
        if(sum(idx)>3)
            o.p = polyfit([x(idx) o.n],[estfit 0],1);
            o.estimated = round(o.i*o.p(1) + o.p(2));
        else
            o.estimated = m;
        end

        
    else
        if(o.p(1) ~= 0 && o.p(2) ~= 0)
            o.estimated = round(o.i*o.p(1) + o.p(2));
        else
            o.estimated = round(time*(o.n-o.i));
        end
    end

    o.restimated(o.i) = o.estimated;
    
    n = length(varargin);
    if(n>=1 && isa(varargin{1},'function_handle'))
        fun = varargin{1};
        varargout = cell(1,nargout(fun));
        if(n>1)
            [varargout{:}] = fun(varargin{2:end});
        else
            [varargout{:}] = fun();
        end
    else
        varargout = {};
    end
   
    o.delta = tic();
    
    if((o.i/o.n*100<98 || o.hasalredayshown) && (toc(o.start)>o.time_interval || o.i==o.n))
        if(round(o.i/o.n*100)-o.percent>=o.pourcent_interval)
            oldmsg = o.message;
            o.message = message;
            display(o);
            o.message = oldmsg;
            o.percent = round(o.i/o.n*100);
        end
        o.start = tic();
    end
    
    if(~isempty(o.h) && o.i/o.n >= 1)
        close(o.h);
        o.h = [];
    end

end