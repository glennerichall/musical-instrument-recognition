function datatip(text, x, y, ax)

    p2 = get_relative_position(ax,x,y);
    p1 = p2;
    p1(2) = p1(2)+.1;
    
    annotation(gcf,'textarrow', ...
             [p1(1) p2(1)], ...
             [p1(2) p2(2)], ...
            'TextEdgeColor',[0.4196 0.6941 0.2627],...
            'TextBackgroundColor',[0.7333 0.9294 0.5098],...
            'FontSize',16,...
            'FontName','Calibri',...
            'HorizontalAlignment', 'Left', ...
            'String',text);