% FIXME use function sweep
function setdataall(o,data)
	o.data=data;
	for i=1:length(o.childs)
		o.childs{i}.setdataall(data);
	end
end	