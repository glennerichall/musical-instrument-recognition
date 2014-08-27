classdef BenchmarkGUI < handle
	properties (Access = private)
		benchmarkori = [];
		plothandle = [];
		fighandles = [];
	end
	
	properties (SetAccess = private)
		benchmark = [];
	end
	

	properties (Dependent = true)
		varnames = {};
	end
	
	properties (Access=private)
		variables = {};
	end
	
		
	methods
		function o = BenchmarkGUI(benchmark)
			if(nargin==1 && isa(benchmark,'Benchmark'))
				o.benchmark = benchmark.clone();
				o.benchmarkori = benchmark.clone();
                if(~isempty(o.benchmark.varnames))
                    o.varnames = o.benchmark.varnames;
                end
			end
		end
		
		function display(o)
			if(ishandle(o.plothandle))
				delete(o.plothandle);
			end
			if(~isempty(o.benchmark))
				o.fighandles = untitled('untitled_OutputFcn');
				o.plothandle = o.benchmark.plot('Parent',o.fighandles.ConfusionPlotPanel);
				o.drawrectangles();
				set(o.plothandle,'ButtonDownFcn',@(src,evt)o.handleclick());
				BenchmarkGUIContextMenu(o);
				set(o.fighandles.ResetBtn,'Callback',@(src,evt)o.resetview());
				set(o.fighandles.ValidateBtn,'Callback',@(src,evt)o.validatebm());
				set(o.fighandles.IndividualBtn,'Callback',@(src,evt)o.individual());
				set(o.fighandles.SelectBtn,'Callback',@(src,evt)o.selectfeaturesnotax());
				set(o.fighandles.ClearBtn,'Callback',@(src,evt)o.cleartaxselection());
				set(o.fighandles.SaveMenu,'Callback',@(src,evt)o.savebenchmark());
				set(o.fighandles.OpenMenu,'Callback',@(src,evt)o.openbenchmark());
				set(o.fighandles.kFoldsSilder,'Callback',@(scr,evt)o.setkfold());
				set(o.fighandles.XlsBtn,'Callback',@(src,evt)o.plotxls(false));
				
				set(o.fighandles.kFoldsText,'String',num2str(o.benchmark.kfolds));
				set(o.fighandles.kFoldsSilder,'Value',o.benchmark.kfolds/100);
				set(o.fighandles.FilesText,'String',o.benchmark.maxperclass);
				
			else
% 				o.fig= untitled();
% 				enable='off';
			end


		end
		function setcontextmenu(o,menu)
			set(o.plothandle,'uicontextmenu',menu);
		end
		function h = getcontextmenu(o,menu)
			h = uicontextmenu('Parent',o.fighandles.output);
		end		
		function delete(o)
			if(ishandle(o.plothandle))
				delete(o.plothandle);
			end
		end
		function vn = get.varnames(o)			
			vn = [];

			for i=1:length(o.variables)
				str = o.variables{i};
				toks = strsplit(str,'.');
				
				if(isempty(vn))
					vn = struct();
					if(length(toks)==2)
						vn.name=toks{1};
						vn.varnames={toks{2}};	
					elseif(length(toks)==1)
						vn.name='others';
						vn.varnames={toks};
					else
						%TODO error
					end
					continue;
				end
				
				if(length(toks)==2)
					idx = strcmp({vn.name},toks{1});
					if(~any(idx))
						vn(end+1).name = toks{1};
						vn(end).varnames = {toks{2}};	
					else
						vn(idx).varnames{end+1} = toks{2};		
					end
					
				elseif(length(toks)==1)
					idx = strcmp([vn.name],'others');
					if(~any(idx))
						vn(end+1).name = 'others';
						vn(end).varnames = {toks};	
					else
						vn(idx).varnames{end+1} = toks;		
					end
				else
					% TODO error
				end
			end
		end
		function set.varnames(o,vn)
			o.variables = vn;
		end		
		
		handleclick(o)
		plottax(o)
		removeclass(o)
		displaytaxonomy(o)
		out = hittest(o,tax,xyz)
		groupkeys(o)
		drawrectangles(o,tax,m,style,width)
		validatebm(o)
		resetview(o)		
		plottaxonomy(o)
		plotxls(o,ind)
		
		function individual(o)
			o.benchmark.taxonomy.crop(1);
			o.display();
		end
		function cleartaxselection(o,tax)
			if(nargin==1)
				o.benchmark.taxonomy.sweep(@o.cleartaxselection);
				
			else
				tax.data.selection = false(1,length(tax.data.selection));
			end
		end
		function savebenchmark(o)
			bm = o.benchmark;
			uisave('bm',bm.name);
		end
		function openbenchmark(o)
			[filename,PathName] = uigetfile();
			temp = load([PathName filename]);
			o.benchmark = temp.bm;
			o.benchmarkori = temp.bm.clone();
            o.resetview();
            if(~isempty(temp.bm.varnames))
                o.varnames = temp.bm.varnames;
            end
		end		
		function selectfeaturesnotax(o)
			strs = get(o.fighandles.FeatureSelectionDD,'String');
			idx = get(o.fighandles.FeatureSelectionDD,'Value');
			o.benchmark.selection = strs{idx};
			n = o.benchmark.kfolds * length(o.benchmark.featureset.obsnames) ...
				+ o.benchmark.kfolds;
			wb = waitbargh(n,'window_options',...
				{'WindowStyle','modal'},...
				'isgraphic',true,'time-interval',0,'pourcent-interval',0);	
			% TODO waitbar update in select
			o.benchmark.select();
			o.benchmark.validate();
			delete(wb);
			o.display();
		end
		function selectfeatures(o,selection)
			tax = o.hittest();
			n = o.benchmark.kfolds * length(o.benchmark.featureset.obsnames) ...
				+ o.benchmark.kfolds;
			wb = Waitbargh(n,'window_options',...
				{'WindowStyle','modal'},...
				'isgraphic',true,'time-interval',0,'pourcent-interval',0);				
			o.benchmark.selection = selection;
			o.benchmark.seqsel(tax,'waitbar',wb);
			o.benchmark.validate('waitbar',wb);
			delete(wb);
			o.display();
		end
	end

	
	methods (Access = private)
		function setkfold(o)
		o.benchmark.kfolds = ceil(get(o.fighandles.kFoldsSilder,'Value')*100);
			set(o.fighandles.kFoldsText,'String', num2str(o.benchmark.kfolds));
		end
		
		function setnfiles(o)
		end
		
    end
    
    events
        Clicked
    end
end