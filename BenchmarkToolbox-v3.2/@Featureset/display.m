function display(o)
	if(isempty(o.data))
		disp('Empty featureset');
	else
		[m n] = size(o);
		disp(['Features [' num2str(m) 'x' num2str(n) ']']);
	end
end