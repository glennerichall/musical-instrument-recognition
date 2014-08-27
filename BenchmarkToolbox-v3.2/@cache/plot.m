function plot(o)  
    tot = o.hits+ o.miss;
    bar([o.hits/tot, o.miss/tot]);
end