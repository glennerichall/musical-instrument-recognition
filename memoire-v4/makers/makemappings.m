functions = script2struct('makefunctions');
params = script2struct('makeparameters');

% basic mappings -----------------------------------------------
for mappinggroup=fieldnames(functions)'
    for mapping=fieldnames(functions.(mappinggroup{:}))'
        if(strcmp(mappinggroup{:},'classifier'))
            mappings.(mappinggroup{:}).(mapping{:}) = MappingClassifier();
        elseif(strcmp(mappinggroup{:},'reduction'))
            mappings.(mappinggroup{:}).(mapping{:}) = MappingWrapper();
        else
            mappings.(mappinggroup{:}).(mapping{:}) = MappingFun();
        end
        mappings.(mappinggroup{:}).(mapping{:}).trainfun = functions.(mappinggroup{:}).(mapping{:}).train;
        mappings.(mappinggroup{:}).(mapping{:}).mapfun = functions.(mappinggroup{:}).(mapping{:}).map;
        mappings.(mappinggroup{:}).(mapping{:}).name = mapping{:};
        if(isfield(functions.(mappinggroup{:}).(mapping{:}),'trainonly'))
            if(functions.(mappinggroup{:}).(mapping{:}).trainonly)
                mappings.(mappinggroup{:}).(mapping{:}).trainonly = true;
            end
        end
    end
end

Id = MappingOne;
Null = MappingZero;

% mapping arrays -----------------------------------------------
for mappinggroup=fieldnames(mappings)'
    c = struct2cell(mappings.(mappinggroup{:}));
    if(~strcmp(mappinggroup{:},'classifier'))
        arrays.(mappinggroup{:}) = [Id,c{:}]';
    else
        arrays.(mappinggroup{:}) = [c{:}]';
    end
end
clear c;

Validate = Validation;

% mapping parameters -----------------------------------------------
for mappinggroup=fieldnames(params)'
    for mapping=fieldnames(params.(mappinggroup{:}))'
        p = MappingOne;
        for paramname=fieldnames(params.(mappinggroup{:}).(mapping{:}))'
            p = p * MappingParameter.expand(paramname{:},params.(mappinggroup{:}).(mapping{:}).(paramname{:}));
            parameters.(mappinggroup{:}).(mapping{:}) = p;
        end
    end
end

% mapping optimizations -----------------------------------------------
for mappinggroup=fieldnames(mappings)'
    for mapping=fieldnames(mappings.(mappinggroup{:}))'
        if(isfield(parameters,mappinggroup{:}))
            if(isfield(parameters.(mappinggroup{:}),mapping{:}))
                optimization.(mappinggroup{:}).(mapping{:}) = ...
                    mappings.(mappinggroup{:}).(mapping{:}) * parameters.(mappinggroup{:}).(mapping{:});
            end
        end
    end
end

clear mappinggroup mapping functions paramname p params;