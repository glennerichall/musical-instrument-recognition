% Loads and filter files
% date : 2011-12-14
% author : Glenn-Eric Hall
% rev. 1.0

if(~exist('options','var'))
    makeconfiguration;
end

if(~exist('map','var'))
	makeinstruments;
end

funkey = @(x) map(upper(x(end-8:end-7)));
funinfo = @(x) struct(...
    'articulation',upper(x(end-6:end-5)),...
    'dynamic',upper(x(end-4)), ...
    'name',funkey(x), ...
    'key',x(end-8:end-7));


params = struct2args(options.fileset);
params = [{'funkey',funkey,'funinfo',funinfo},params];
clear funkey funinfo;

fileset = Fileset(params{:});
clear params;

if(options.environment.cache.usecache)
    fileset.load('folder',options.environment.data.basedir,...
        'cache',[options.environment.cache.basedir filesep options.fileset.cache]);
else
    fileset.load('folder',options.environment.data.dir);
end

fileset.filter(...
	'key',mapmany(usedkeys),...
	'length',['<=' num2str(options.fileset.maxlength)],...
    'length',['>=' num2str(options.fileset.minlength)],...
    'info.articulation',options.fileset.articulations,...
    'info.dynamic',options.fileset.dynamics);
clear map mapmany keys instruments unusedkeys usedkeys;

idx = randi(length(fileset.files),[1,min(length(fileset.files),options.fileset.maxfile)]);
fileset = fileset.subset(idx);
clear idx;
