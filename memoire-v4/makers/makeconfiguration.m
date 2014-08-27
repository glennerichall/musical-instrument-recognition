% Specify default values for options
% date : 2011-12-14
% author : Glenn-Eric Hall
% rev. 1.0

%% 
clear options benchmark;

defaultoptions = script2struct('makedefaultoptions');

if(exist('makeoptions','file')==2)
    useroptions = script2struct('makeoptions');
end
options = process_options(useroptions,defaultoptions,'recurse');
clear defaultoptions;

if(exist('useroptions','var'))
    options = mergestructs(useroptions,options,'recurse');
end
clear useroptions;

%% ENVIRONMENT
fn = fieldnames(options.environment);
for i=1:length(fn)
    if(isfield(options.environment.(fn{i}),'basedir'))
        options.environment.(fn{i}).basedir = ...
        [options.environment.drive '\' options.environment.basedir '\' ...
            options.environment.(fn{i}).basedir];
        
        if(~exist(options.environment.(fn{i}).basedir,'dir'))
            mkdir(options.environment.(fn{i}).basedir);
        end        
    end
    
    if(isfield(options.environment.(fn{i}),'file'))    
        options.environment.(fn{i}).file = ...
        [options.environment.(fn{i}).basedir '\'...
            options.environment.(fn{i}).file ...
            options.environment.(fn{i}).extension];
    end

end
clear i fn;