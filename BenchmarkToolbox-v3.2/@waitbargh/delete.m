function delete(o)
    if(ishandle(o.h))
        close(o.h);
    end
    o.h = [];
end