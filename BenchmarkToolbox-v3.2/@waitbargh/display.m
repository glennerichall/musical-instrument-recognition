function display(o, varargin)
% TODO comments
% TODO display text line on single line
    hrs = floor(o.estimated/(60*60));
    d = o.estimated-60*60*hrs;
    min = floor(d/60);
    d = d-60*min;
    sec = d;

    if(o.i==0)
        return;
    end
    
    message = process_options(varargin,'message',o.message);
    if(isempty(o.message))
        message = '';
    end
    
    % TODO format string to 2 decimals
    if(o.i==o.n)
        str = sprintf('%s \n finished', message);
    elseif(o.estimated < 60)
        str = sprintf('%s \n %d sec remaining', message,sec);
    elseif(o.estimated < 60*60)
        str = sprintf('%s \n %d min %d sec remaining', message,min,sec);
    else
        str = sprintf('%s \n %d hrs %d min %d sec remaining', message,hrs,min,sec);
    end

    

    
    if(length(varargin)==1 && strcmpi(varargin{1},'dispplot'))
        
        x = 1:o.j;
        plot(x,o.estfit(x));
        hold on;
        plot([0 o.n],[o.p(2) o.n*o.p(1)+o.p(2)], 'red');
        plot(o.i,o.estimated,'marker','o', 'color','green');
        plot(x,o.restimated(x),'color','green');
        mea = mean(o.time(1:o.i));
        
        plot([0 o.n], [mea/2 mea/2], 'linestyle','-', 'color','orange');
        hold off;
        drawnow;
    else
        o.hasalredayshown = true;
        if(~isempty(o.h))
            waitbar(o.i/o.n, o.h, str);
            drawnow;
        else
            str = [num2str(round(o.i/o.n*100)) '% done, ' str];
            disp(str);
        end
    end
end