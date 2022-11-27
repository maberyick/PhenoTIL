function Z=getZernikeMomentsImg(I,maxOrder)

I=double(I);

N = []; M = [];
for n = 0:maxOrder
    N = [N n*ones(1,n+1)];
    M = [M -n:2:n];
end

Z=[];

for i=1:length(N)
    [~, a, phi] = Zernikmoment(I,N(i),M(i));
    Z=[Z a phi];
end

end