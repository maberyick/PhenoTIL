function E = getNucEntropy(I)
%GETNUCENTROPY gets the entropy of a set of pixels

J=I(:)';

% TODO: This should be done automatically
ctrs=[12.75 38.25 63.75 89.25 114.75 140.25 165.75 191.25 216.75 242.25];

H=hist(double(J),ctrs);
P=H/sum(H);

val=0;
for i=1:10
    if(P(i)~=0)
        val=val+P(i)*log2(P(i));
    end
end

E=val*-1;

end