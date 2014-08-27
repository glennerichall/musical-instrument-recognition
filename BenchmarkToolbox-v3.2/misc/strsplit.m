function toks = strsplit(str, delimiter)
    i=1;
    while(~isempty(str))
        [tok,str] = strtok(str,delimiter); %#ok<STTOK>
        toks{i} = tok;
        i=i+1;
    end
end