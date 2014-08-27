function plotcontourgh(contour,values,varargin)
        
    
    m = colormap();
    l = length(m);
    
    if(nargin>=2)
        [mn mx] = process_options(varargin,'min',min(values),'max',max(values));
        values = values-mn;
        if(mx > 0)
            values = bsxfun(@rdivide,values,mx);
        end
        values = round( values * (l-1) ) +1;
    else
        values = ones(length(contour),1);
    end
    
    
    parent = process_options(varargin,'Parent',gca);
    ih = ishold(parent);

    
    for i=1:length(contour)
        plot(parent,[contour{i}(1,:)],[contour{i}(2,:)],...
            'Color', m(values(i),:), 'LineWidth', 2);

        if(i==1)
            hold(parent,'on');
        end
    end

    if(~ih)
        hold(parent,'off');
    end
   
end