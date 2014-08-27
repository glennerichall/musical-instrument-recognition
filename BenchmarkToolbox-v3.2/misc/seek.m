function o = seek(s,field,child)
    o = [];
    if(isfield(s,field))
        o = s.(field);
    end

    if(isfield(s,child))
        o = arrayfun(@(x) seek(x,field,child), [s.(child)],'uniformoutput',false);
        o = [o{:}];
    end