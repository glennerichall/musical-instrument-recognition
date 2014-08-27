clc;
n = 100;

wb = waitbargh(n);
h=tic();
s=tic();
for i=1:n
    t = rand();
    while(toc(h)<t),end;
    wb = update(wb);
    display(wb,'dispplot');
    h=tic();
end
toc(s);
close(gcf);