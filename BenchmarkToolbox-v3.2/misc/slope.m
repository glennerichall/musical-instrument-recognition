function s = slope(y)
	p = polyfit(1:length(y),y,1);
	y1 = p(end);
	y2 = sum(p);
	
	s = y2-y1;
	
end