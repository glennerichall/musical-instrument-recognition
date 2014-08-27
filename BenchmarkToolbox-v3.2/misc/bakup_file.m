function bakup_file(filename)
% TODO comments
    f = @(x) strrep(strrep(getfield(dir(x),'date'), ' ','_'),':','');
    if(exist(filename,'file'))
        [pathstr, name, ext] = fileparts(filename);
        copyfile(filename, [pathstr filesep name '_' ...
            f(filename) ext], 'f');
        delete(filename);
    end
end