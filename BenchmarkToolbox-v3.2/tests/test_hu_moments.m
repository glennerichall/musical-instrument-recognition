clc;

moments = hu_moments([1;1]);
assert(all(~moments));


disp('all went ok');