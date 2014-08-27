classdef BenchmarkDummy < Benchmark
    properties
        targets;
        predictions;
    end
    
    methods
        function o = BenchmarkDummy(targets,predictions,tax)
            if(isa(targets,'Benchmark'))
                bm = targets;
                targets = bm.fileset.keys;
                predictions = bm.results.predictions';
                tax = bm.taxonomy;
            end
            
            o.taxonomy = tax.clone();
            o.targets = targets;
            o.predictions = predictions;
            o.results = BMResult(tax.keys,targets,'Dummy');
            o.results.confusionmat(targets,predictions);
            o.kfolds = 1;
            
            files = struct('key',o.targets);
            o.fileset = Fileset('files',files);
            o.taxonomy.sweep(@o.populatetaxonomy);
        end
        
        function export2excel(o,dst)
            if(~exist(dst,'dir'))
                mkdir(dst);
            end

            fun = @(t)evalif(t.depth>0,@(t)t.data.result.plotxls('dir',dst),t);
            o.taxonomy.sweep(fun);
        end
        
        function oo = clone(o)
            oo = BenchmarkDummy(o.targets,o.predictions,o.taxonomy);
            files = struct('key',o.targets);
            oo.fileset = Fileset('files',files);
        end
        
        function prepare(o)
            map = containers.Map;
            keys = o.fileset.keys;
            for i=1:length(o.targets)
                map(o.targets{i}) = keys{i};
            end
            o.targets = o.fileset.keys;
            for i=1:length(o.predictions)
                o.predictions{i} = map(o.predictions{i});
            end
            
            if(~isempty(o.taxonomy))
                o.results = BMResult(o.taxonomy.keys,o.targets,'Dummy');
                o.results.confusionmat(o.targets,o.predictions);
            end
        end
        
        function validate(o,varargin)
            o.taxonomy.sweep(@o.populatetaxonomy);
        end
        
        function populatetaxonomy(o,tax)
%             idx = ismember(o.targets,tax.keys);
%             tax.data.results = BMResult(tax.keys,o.targets(idx),tax.name);
%             tax.data.results.confusionmat(o.targets(idx),o.predictions(idx));
            if(tax.depth==0)
                return;
            end
            order = {tax.subclasses.name};
            keys = cell(length(o.targets),1);
            predictions = cell(length(o.targets),1);
            for i=1:length(tax.subclasses)
                idx = ismember(o.targets,tax.subclasses(order{i}).keys);
                [keys{idx}] = deal(order{i});
                
                idx = ismember(o.predictions,tax.subclasses(order{i}).keys);
                [predictions{idx}] = deal(order{i});                
            end
            
            idx = ismember(o.predictions,tax.keys) & ismember(o.targets,tax.keys);
    
            tax.data.result = BMResult(order,keys(idx),tax.name);
            tax.data.result.confusionmat(keys(idx),predictions(idx));
        end
    end
    
end

