classdef Waitbargh < handle
    
    properties (Access = private)
        n;
        delta;
        start;
        i;
        j;
        estimated;
        estfit;
        time;
        message;
        hasalredayshown;
        fun;
        percent;
        restimated;
        p;
        time_interval;
        pourcent_interval;
        h;
    end
    
    methods
        function o = Waitbargh(n, varargin)
        % TODO comments
            o.n = n;

            [message, isgraphic, fun, window_options, time_interval, pourcent_interval] ...
                = process_options(varargin,...
                'message', {}, 'isgraphic', false, 'fun', [],...
                'window_options',{},'time-interval',5,'pourcent-interval',1); %#ok<*PROP>

            if(isgraphic)
                o.h = waitbar(0, message, window_options{:});
            else
                o.h = [];
            end
            o.delta = tic();
            o.start = tic();
            o.i = 0;
            o.j = 0;
            o.estimated = 0;
            o.estfit = zeros(1,n);
            o.time = zeros(1,n);
            o.message = message;
            o.hasalredayshown  = false;
            o.fun = fun;
            o.percent = 0;
            o.restimated = zeros(1,n);
            o.p = [0 0];
            o.time_interval = time_interval;
            o.pourcent_interval = pourcent_interval;
            
        end
        [o, varargout] = update(o,varargin)
        display(o, varargin)
        delete(o)
    end
end