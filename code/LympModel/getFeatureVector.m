function featureVector = getFeatureVector( inputFolder,filename,type )
%GETFEATUREMATRIX Summary of this function goes here
%   Detailed explanation goes here

if strcmp(type,'lymp')
    isLymp=1;
else
    isLymp=0;
end

I=imread([inputFolder '/imgs/' filename '.png']);
M=imread([inputFolder '/masks/' type '/' filename '_mask.png']);
                
[~,nucleiFeatures,~]=getNucleiFeatures(I,M);

numNuclei=length(nucleiFeatures);
labels=ones(numNuclei,1)*isLymp;
featureVector=[nucleiFeatures labels];

end

