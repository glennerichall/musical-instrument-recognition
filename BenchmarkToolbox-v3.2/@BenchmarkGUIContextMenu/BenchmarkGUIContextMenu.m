classdef BenchmarkGUIContextMenu < handle
	properties (Access = private);
		bmgui = [];
		groupmenu;
		removemenu;
		plotmenu;
		resetmenu;
		displaytaxonomymenu;
		validatemenu;
		featuresmenu;
        taxnamemenu=[];
	end
	properties (SetAccess=private)
		contextmenu;
	end
	properties (GetAccess=private)
		varnames;
	end
	
	methods
		function o = BenchmarkGUIContextMenu(benchmarkGUI)
			o.bmgui = benchmarkGUI;
            o.bmgui.addlistener('Clicked',@(src,evt)o.bmguiclicked(src));
			o.contextmenu = o.bmgui.getcontextmenu();
			
			% FIXME remove src,evt parameters to clean code
			
			
			% BenchmarkGUI action menus
            o.taxnamemenu = uimenu(o.contextmenu,'Label','','Callback',@(src,evt)o.bmgui.displaytaxonomy());
			if(o.bmgui.benchmark.taxonomy.depth>1)
				o.groupmenu = uimenu(o.contextmenu ,'Separator','on','Label','Group','Callback',@(src,evt)o.bmgui.groupkeys());
				o.removemenu = uimenu(o.contextmenu ,'Label','Remove','Callback',@(src,evt)o.bmgui.removeclass());
				o.plotmenu = uimenu(o.contextmenu ,'Label','Plot','Callback',@(src,evt)o.bmgui.plottaxonomy());
				plotxlsmenu = uimenu(o.contextmenu ,'Label','PlotXls');
				uimenu(plotxlsmenu ,'Label','Taxonomy','Callback',@(src,evt)o.bmgui.plotxls(true));
				uimenu(plotxlsmenu ,'Label','Individual','Callback',@(src,evt)o.bmgui.plotxls(false));
                separator='off';
            else
                separator='on';
			end
			selectionmenu = uimenu(o.contextmenu ,'Label','Selection');
			o.displaytaxonomymenu = uimenu(selectionmenu ,'Label','Forward','Callback',@(src,evt)o.bmgui.selectfeatures('Forward'));
			o.displaytaxonomymenu = uimenu(selectionmenu ,'Label','Backward','Callback',@(src,evt)o.bmgui.selectfeatures('Backward'));
			
			% BenchmarkGUIContextMenu menus
			o.featuresmenu = uimenu(o.contextmenu ,'Label','Features','Callback',...
				@(src,evt) o.displayfeatures(src));
			
			o.createfeaturesmenu(o.bmgui.varnames,o.featuresmenu,1);
			
			o.bmgui.setcontextmenu (o.contextmenu);
		end
	end
	
	methods (Access = private)
		k = createfeaturesmenu(o,varnames,menu,k)
		displayfeatures(o,menu)
		setselection(o,menu,sidx)
        function bmguiclicked(o,src)
            set(o.taxnamemenu, 'Label',src.hittest().name);
            
        end
	end
end