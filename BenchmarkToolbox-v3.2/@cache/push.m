function push(o, fun, params, val)

    hash = @(f, p) [to_string(f) to_string(p)];
    
    h = hash(fun,params);
    date = getFunDate(fun);

    A.data = val;
    A.date = date;
    o.cache(h) = A;
    
    o.miss = o.miss + 1;
end