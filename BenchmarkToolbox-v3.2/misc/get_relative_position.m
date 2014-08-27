function pos = get_relative_position(ah, x, y)
	pos_ = get(ah,'Position');
	XLim = get(ah,'XLim');
	YLim = get(ah,'YLim');
	
	if(strcmp(get(ah,'XScale'),'log'))
		width = log10(XLim(2)) - log10(XLim(1));
		dx = pos_(3)/width;
		px = log10(x) - log10(XLim(1));
		pos(1) = pos_(1) + px*dx;
	else
		width = XLim(2)-XLim(1);
		dx = pos_(3)/width;
		px = x-XLim(1);
		pos(1) = pos_(1) + px*dx;
	end
	
	if(strcmp(get(ah,'YScale'),'log'))
		height = log10(YLim(2)) - log10(YLim(1));
		dy = pos_(4)/height;
		py = log10(y) - log10(YLim(1));
		pos(2) = pos_(2) + py*dy;
	else
		height = YLim(2)-YLim(1);
		dy = pos_(4)/height;
		py = y-YLim(1);
		pos(2) = pos_(2) + py*dy;
	end
end