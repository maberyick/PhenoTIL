function E = getNucEntropy(I)
%GETNUCENTROPY Summary of this function goes here

J=I(:)';

%TODO: perform this center calculation automatically
ctrs=[12.75 38.25 63.75 89.25 114.75 140.25 165.75 191.25 216.75 242.25];

%if useWeights
%    W=[0.1 0.2 0.3 0.4 .5 .6 .7 .8 .9 1];
%else
%W=ones(1,10);
%end

H=hist(double(J),ctrs);
P=H/sum(H);

val=0;
for i=1:10
    if(P(i)~=0)
        %val=val+P(i)*log2(P(i))*W(i);
        val=val+P(i)*log2(P(i));
    end
end

E=val*-1;

end

