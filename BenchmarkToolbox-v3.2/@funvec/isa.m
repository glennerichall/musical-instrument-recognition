function o = isa(o,name)
	o = any(strcmp({'funvec','function_handle'},name));
end