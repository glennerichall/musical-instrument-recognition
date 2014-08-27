% export cross-validate results in xlsm file
% date : 2012-03-25
% author : Glenn-Eric Hall
% rev. 1.0



if(~exist(options.results.basedir,'dir'))
    mkdir(options.results.basedir);
end

% plot the taxonomy confusion matrices
filename = options.results.taxonomycconfusion;
if(exist(filename,'file'))
    delete(filename);
end
tax.treefun(@treeplotxls,'filename',filename)

treetax = tax.clone();
% plot the family confusion matrices
filename = options.results.familyconfusion;
if(exist(filename,'file'))
    delete(filename);
end
maketaxonomyfamily;
taxfamily = tax;
taxfamily.treefun(@treeparseconfmat,cfmat);
taxfamily.treefun(@treeplotxls,'filename',filename)

% plot the instruments confusion matrix
filename = options.results.instrumentconfusion;
if(exist(filename,'file'))
    delete(filename);
end
maketaxonomydirect;
taxinstruments = tax;
taxinstruments.treefun(@treeparseconfmat,cfmat);
taxinstruments.treefun(@treeplotxls,'filename',filename)

tax = treetax;
clear filename taxinstruments taxfamily treetax;