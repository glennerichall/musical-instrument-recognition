function groups = gplotgh(A, labels, p)
% TODO comments
    set_matlab_bgl_default(struct('full2sparse',1));
    n = size(A,1);
    edges = bsxfun(@rdivide,A,sum(A,2));
    edges = round(edges*100);
    
    edges(edges<p) = 0;
    edges(logical(eye(n))) = 0;

    xy = zeros(n,2);
    MyGraph.X = xy(:,1);
    MyGraph.Y = xy(:,2);
   
    MyGraph.EdgeLabels = strcat(...
        arrayfun(@num2str,edges,'UniformOutput',false), ...
        ' %');
    
    edges(logical(edges)) = 1;
    MyGraph.A = edges;
    MyGraph = EliminateStates(MyGraph, sum(edges+edges',2));
    edges = MyGraph.A;
    EdgeLabels = MyGraph.EdgeLabels;
    
    c = components(edges+edges');
    c = arrayfun(@(x) find(c==x),unique(c), ...
            'UniformOutput',false);
        
    groups = [];
    for i=1:length(c)
        idx = c{i};
        plot(edges(idx,idx),labels{end}(idx), EdgeLabels(idx, idx)); 
        
        groups{i} = labels{end}(idx); %#ok<AGROW>
    end
end

function plot(A, StateLabels, edgelabels)
    figure();

    n = size(A,1);
    r=20;
    d = 2*pi/n;
    theta = d:d:2*pi;
    
    MyGraph.X = r*sin(theta)';
    MyGraph.Y = r*cos(theta)';
    MyGraph.StateLabels = StateLabels;
    MyGraph.EdgeLabels = edgelabels;
    MyGraph.A = A;
    
    DirectGPlot(MyGraph);
%     set(gca,'Position',[.01 .01 .99 .99]);
%     set(gca,'PlotBoxAspectRatio',[1000 500 1]);
%     m = max([MyGraph.X,MyGraph.Y]);
%     mn = min([MyGraph.X,MyGraph.Y]);
%     d = [m(1)-mn(1) m(2)-mn(2)];
%     set(gca,'YLim',[mn(2)-abs(d(2))*0.15, m(2)+abs(d(2))*0.15]);
%     set(gca,'XLim',[mn(1)-abs(d(1))*0.15, m(1)+abs(d(1))*0.15]);

    set(gca, 'XTick',[]);
    set(gca, 'YTick',[]);
end