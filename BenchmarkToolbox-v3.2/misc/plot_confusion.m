
function h = plot_confusion(confmat, instruments, varargin)
% TODO comments
    if(length(varargin)>=1 && ischar(varargin{1}))
        [pathstr, name, ext] = fileparts(varargin{1});
        
        if(strcmpi(ext, '.xlsm'))
            p = regexprep(mfilename('fullpath'), mfilename(), 'template.xlsm');
            copyfile(p,varargin{1},'f');
            plot_xls_confusion(instruments, confmat, varargin{1});
        else
            h = do_plot(confmat, instruments, varargin{:});
        end
    else
        h = do_plot(confmat, instruments, varargin{:});
    end
end




function h = do_plot(confmat, instruments, varargin)
% 	figure();
    missrate = @(x) 1-trace(x)/sum(x(1:end)); % miscalssification rate
	parent = process_options(varargin,'parent',[]);
	if(isempty(parent))
		h = axes();
	else
		h = axes('Parent',parent);
	end
	hh = imagesc(bsxfun(@rdivide,confmat,sum(confmat,2)) * 100,'Parent',h);
	set(hh,'HitTest','off');
	[titl, fontsize, hangle, space, unused] = process_options(varargin, ...
        'title', [], ...
        'FontSize',5, ...
        'HAngle', 45, ...
        'Space', 1); %#ok<NASGU>
	title(h,[titl, 'misclassification rate: ', num2str(missrate(confmat))]);
	set(h,'YTick',1:length(instruments));
	set(h,'XTickLabel',instruments);	
	set(h,'YTickLabel',instruments);	
	set(h,'XTick', 1:length(instruments));
	set(h,'FontSize',fontsize);
	rotateticklabel(h,hangle, ...
        'reverse_yaxis',true,...
        'space',space,...
        'FontSize',fontsize);
    
    % esthetics 
	%FIXME opens a new figure even if specifies axes
    cmap = colormap(h,'bone');
    cmap = colormap(h);
    cmap(end:-1:1,:) = cmap(1:end,:);
    colormap(h,cmap);
    clear cmap;
%     colorbar;    
    
%     set(gca,'Position',[0.1396 0.1608 0.6824 0.7559]);
end




function confusion = plot_xls_confusion(instruments, confusion, xlsfile)

    expected = union(find(sum(confusion,2)>0), find(sum(confusion,1)>0));

    % [keys values] = instr();   
    % 
    % instruments = find(expected);
    % success = success(instruments);
    % expected = expected(instruments);
    % values = values(instruments);
    % confusion = confusion(instruments,instruments);
    % 
    % bar(success ./ expected);
    % set(gca,'XTick',1:length(values));
    % set(gca,'XTickLabel',values)
    % rotateticklabel(gca,45);
    % set(gca,'XLim',[1 length(values)]);
    % set(gca,'Position',[0.045 0.152 0.928 0.821]);

    confusion = confusion(expected, expected);

    for i=1:size(confusion,1)
        str = [];
        for j=1:size(confusion,2)
            str = sprintf('%s %d ', str, confusion(i,j));
        end
    %     disp(str);
    end

    n = length(expected);
    xlswrite(xlsfile, confusion, 'Feuil1','B2');
    xlswrite(xlsfile, instruments(expected)', 'Feuil1', strcat('A2:A',num2str(n+1)));

    if(n>26)
        col = strcat(char(n/26+'A'-1),char(mod(n,26)+'A'));
    else
        col = char(n+'A');
    end
    xlswrite(xlsfile, instruments(expected), 'Feuil1', strcat('B1:',col,'1'));
end