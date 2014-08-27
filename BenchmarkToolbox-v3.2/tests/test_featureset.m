clc;
clearvars;

fs = Featureset('data',[1 2 3 4;5 6 7 8]);
display(fs);
assert(all(size(fs)==[2 4]));
assert(size(fs,1)==2);
assert(size(fs,2)==4);
assert(all(size(subset(fs,1,2:3))==[1,2]));
assert(all(size(fs(:,2:4))==[2,3]));
assert(all(size(fs(:))==[2,4]));
assert(all(all([fs{:}]==[1 2 3 4;5 6 7 8])));
assert(fs{2,2} == 6);


fs = Featureset('data',{[1 2 3 4;5 6 7 8];[9,10,11,12]});
display(fs);
assert(all(size(fs)==[2 4]));
assert(all(size(fs(1))==[1 4]));