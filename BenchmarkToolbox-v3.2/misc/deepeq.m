function r = deepeq(c1, c2)
% DEEPEQ compares the content of two cell arrays
% r = deepeq(c1, c2) returns true if and only if all the elements
% of arrays in cell c1 are the same of the arrays in cell c2

    r = all(size(c1)==size(c2));
    r = r && all(arrayfun(@(i) all(all(c1{i} == c2{i})),1:length(c1)));