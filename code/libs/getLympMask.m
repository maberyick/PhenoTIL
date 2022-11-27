function [bwLymp, bwnonLymp] = getLympMask(img)
lympModel = load('lymp_svm_matlab_wsi.mat');
lympModel = lympModel.model;
% Generate the nuclei mask
mskl = getWatershedMask(img,1,4,12);    
[nucleiCentroids,feat_simplenuclei] = get_localcellfeatures(img,mskl);
isLymphocyte = (predict(lympModel,feat_simplenuclei(:,1:7)))==1;
lympCentroids=nucleiCentroids(isLymphocyte==1,:);
nonLympCentroids=nucleiCentroids(isLymphocyte~=1,:);
%
rndLymp = round(lympCentroids);
rndnonLymp = round(nonLympCentroids);
bwLymp = bwselect(mskl,rndLymp(:,1),rndLymp(:,2));
bwnonLymp = bwselect(mskl,rndnonLymp(:,1),rndnonLymp(:,2));
end