function [contours, values] = contourgh(xgram,varargin)
        
    if(ischar(xgram))
        fun = funchain(@wavread,[1,2],@chromagram_IF);
        xgram = fun(xgram);
    end

    normal = any(strcmpi(varargin,'normal'));
    force1 = any(strcmpi(varargin,'force1contour'));
    allcontours = any(strcmpi(varargin,'allcontours'));
    plotgram = any(strcmpi(varargin,'plotgram'));
    box = ~any(strcmpi(varargin,'nobox'));
    
    [ncontour, medfilt] = process_options(varargin, ...
        'ncontour', [], 'median', [1,5]);
    
    smooth = any(strcmpi(varargin,'smooth') | strcmpi(varargin,'median'));   
    
    if(box)
        s = zeros(1,size(xgram,2));
        xgram = [s; xgram; s];
    end
    
    if(smooth)
        xgram = medfilt2(xgram, medfilt);
    end
   
    nbin = size(xgram,1);
    
	
    if(isempty(ncontour))
        c = contourc(xgram);
    else
        c = contourc(xgram,ncontour);
    end
    
    i=1;
    j=1;
    c_data = {};
    c_isolines = [];
    n = length(c);
    while(i<=n)
        l=c(2,i);
        c_data{j} = c(:,i+1:i+l); %#ok<AGROW>
        if(box)
            c_data{j}(2,:) = c_data{j}(2,:)-1; %#ok<AGROW>
        end
        c_isolines(j) = c(1,i); %#ok<AGROW>
        i = i+l+1;
        j = j+1;
    end
    
    c = [c_data{:}];

     %selection d'une seule forme
    if(~allcontours)
%         if(box)  
%             [m, idx] = max(sum(xgram,2)); 
%             idx = idx-1;
%             up=idx+1;
%             down=idx-1;           
%             idxs = cellfun(@(x) all(x(2,:)<up) && all(x(2,:)>down), c_data);
%         else
            h = hist(c(2,:),1:nbin);    
            [m, idx] = max(h);           
            up=idx+1;
            down=idx-1;      
            while(up+1<=nbin && h(up+1) > 0), up=up+1;end;
            while(down-1>=1 && h(down-1) > 0), down=down-1;end;
            idxs = cellfun(@(x) mean(x(2,:))<up && mean(x(2,:))>down, c_data);
%         end
        c_data = c_data(idxs);
        c_isolines = c_isolines(idxs);
        c = [c_data{:}];        
    end
    

    
    if(normal)
        % normalize contour by c = (c-min)/(max-min)
        norm = @(x) bsxfun(@rdivide,bsxfun(@minus,x,...
            min(c,[],2)),max(c,[],2)-min(c,[],2))*10;
        
        c_data = cellfun(norm, c_data, 'uniformoutput',false);
    end
    
    if(nargout == 0)
%         figure();
        ih = ishold();
        
        if(plotgram)
            subplot(2,1,1);
            imagesc(xgram(2:end-1,:));
            subplot(2,1,2);
        end
        m = colormap();
        l = length(m);
        c_isolines = c_isolines-min(c_isolines);
        if(max(c_isolines) > 0)
            c_isolines = bsxfun(@rdivide,c_isolines,max(c_isolines));
        end
        
        c_isolines = round( c_isolines * (l-1) ) +1;
        for i=1:length(c_data)
            plot([c_data{i}(1,:)],[c_data{i}(2,:)],...
                'Color', m(c_isolines(i),:), 'LineWidth', 2);
            
            if(i==1)
                hold on;
            end
        end
        
        if(~ih)
            hold off;
        end
    else
        contours = c_data;
        values = c_isolines;
        
        if(force1)
            if(length(contours)>1)
                contours = {};
                values = {};
            end
        end
    end
end