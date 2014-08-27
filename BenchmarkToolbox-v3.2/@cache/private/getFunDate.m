function date = getFunDate(f)
    t=functions(f);
    for i=1:length(t)
        if(~isempty(t(i).file))
            ti = dir(t(i).file);
            date = ti.datenum;
        else
            date = 0;
        end
    end
end

