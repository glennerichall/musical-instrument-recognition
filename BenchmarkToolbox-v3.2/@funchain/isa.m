function o = isa(o,name)
	o = any(strcmp({'funchain','function_handle'},name));
end