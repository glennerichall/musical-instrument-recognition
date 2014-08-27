classdef Benchmark < handle
	
	properties (Access = private)
		nfeatures = [];
		id = 0;
		taxlster = [];
		fslister = [];
	end
	
	properties (SetAccess = protected)	
		featureset = [];
		% TODO put these results in a class Results
		results = [];
        
	end
	
	properties (GetAccess=private)

		randstream = RandStream.getDefaultStream;
		verbose = false;   
		dosave = false;
		dontrunifexist = false;
		backup = true;
	end
	
	properties (SetObservable)
		maxperclass = inf;  
		taxonomy = [];
		fileset = Fileset();;
		name = 'Benchmark';
		selection = []; 		
		extractionfunction = @rawfeatures;
		validationfunction = @discriminantclassify;
		kfolds = [];
        varnames = [];
	end
		
	
	methods
		function o = Benchmark(varargin)			
			if(length(varargin)==1 && ischar(varargin{1})...
					&& exist(varargin{1},'file'))
				o = load(varargin{1});
				o=o.s;
				return;
			end

			% TODO benchmark name static incrementation
			% TODO validate taxonomy, fileset, featureset and options
			% TODO get errors of specified keys ex bm.errors('Acoustic Guitar','Violin');
			% TODO plot excel file
			% TODO format excel plot to consider taxonomy
			% TODO get missclassified files of specified keys
			[o.taxonomy,o.fileset,o.name,o.selection,o.extractionfunction, ...
				o.validationfunction,o.kfolds,o.backup,o.dontrunifexist,...
				o.dosave,o.verbose,o.randstream,o.maxperclass] = ...
				process_options(varargin,'taxonomy',o.taxonomy,'fileset',o.fileset,...
				'name',o.name,'selection',o.selection,...
				'extractionfunction',o.extractionfunction,...
				'validationfunction',o.validationfunction,'kfolds',o.kfolds,...
				'backup',o.backup,'dontrunifexist',o.dontrunifexist,...
				'dosave',o.dosave,'verbose',o.verbose,...
				'randstream',o.randstream,'maxperclass',o.maxperclass);
		
		
			o.prepare();
			
			% FIXME find a way to disable autolisteners
% 			o.taxlster = addlistener(o,'taxonomy','PostSet',@(src,evt)o.taxonomychanged());
% 			o.fslister = addlistener(o,'fileset','PostSet',@(src,evt)o.prepare());
% 			addlistener(o,'extractionfunction','PostSet',@(src,evt)o.extractionfunctionchanged());
		end		
		%------------------------------------------------------------------
		function o = validate(o,varargin)
			o = bmfun(@validate_scalar,o,varargin{:});
		end	
		%------------------------------------------------------------------
		function o = select(o, varargin)
			o = bmfun(@(x) select_scalar(x,varargin{:}),o);
		end			
		%------------------------------------------------------------------
		function o = extract(o)
			o = bmfun(@extract_scalar, o);
		end	
		%------------------------------------------------------------------
		function o = prepare(o)
			o = bmfun(@prepare_scalar,o);
		end
		%------------------------------------------------------------------
		function h = plot(o,varargin)
			h = bmfun(@plot_scalar,o,varargin{:});
        end
        %------------------------------------------------------------------
        function plotxls(o,varargin)
            tax = o.taxonomy;
            conf = o.results.confusion;
            order = o.results.order;
            filename = process_options(varargin,'filename',['c:\temp\' tax.name '.xlsm']);
            plot_confusion(conf,order,filename);
        end
        %------------------------------------------------------------------
        function groupkeys(o,classname)
            tax = o.taxonomy.findnode(classname);
            tkeys = tax.keys;
            if(~isempty(o.fileset))
                fkeys = o.fileset.keys;
                idx = ismember(fkeys,tkeys);
                fkeys(idx) = {tax.name};
                o.fileset.setkeys(fkeys);
                if(~isempty(o.featureset))
                    o.featureset.obsnames = fkeys;		
                end
            end

            if(tax == tax.head())
                tax.crop(1);
            else
                tax.trim(1);
            end
        end
		%------------------------------------------------------------------
		o = run(o,varargin)
		savebm(o, filename)
		display(o)
		mr = missrate(o)
		o = fromlevel(o,l)
		o = clone(o)
		seqsel(o,tax,varargin)
		%------------------------------------------------------------------
	end
	
	methods (Access = private)
		
		classify(o,tax)
		taxonomychanged(o,src,evt)
		function extractionfunctionchanged(o)
			if(isa(o.extractionfunction,'function_handle'))
				
			elseif(isa(o.extractionfunction,'Observation'))
				disp('test');
			end
		end
	end
	
	events
		BeginExtraction;
		EndExtraction;
		BeginPreparation;
		EndPreparation;
		BeginSelection;
		EndSelection;
		BeginValidation;
		EndValidation;
	end
end


