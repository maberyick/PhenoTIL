addpath(genpath('/home/maberyick/Dropbox/local_ed/DPGMM/LympModel'))
trainingFolder='/home/maberyick/Dropbox/local_ed/DPGMM/LympModel/data/training/';
testingFolder='/home/maberyick/Dropbox/local_ed/DPGMM/LympModel/data/testing/';

% BASH EXPORT LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6
% it solves the thing of not loading the library for mexa64
% The prediction is: Lymphocytes is 1 (blue) and Non-Lymp is 0 (red)
%% train a model here
% do in order to solver missing problem: export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6
% --- Feature extraction --- %
folderContents = dir([trainingFolder '/imgs/*.png']);
numFiles=length(folderContents);
featureMatrix=[];
for k=1:numFiles
    [~, filename, ~] = fileparts(folderContents(k).name);
    featVectorLymp=getFeatureVector(trainingFolder,filename,'lymp');
    featVectorNonLymp=getFeatureVector(trainingFolder,filename,'other');
    featureMatrix=[featureMatrix;featVectorLymp;featVectorNonLymp];
end

% --- Model Training --- %
kernel=0;
cmodel=trainSVMModel(featureMatrix(:,1:end-1),featureMatrix(:,end),kernel);

%% test the model here
%I=imread([testingFolder '/imgs/29_38.png']);
I=imread([testingFolder '/imgs/15Img.png']);
M=getWatershedMask(I);
imwrite(M, [testingFolder 'imgs/15WatershedMask.png']);

%M=imread([testingFolder '/imgs/15MaskClean.png']);

% --- Feature extraction --- %
[nucleiCentroids,nucleiFeatures,~]=getNucleiFeatures(I,M);

% --- Classification --- %
numNuc=length(nucleiFeatures);
[LympPredict,~,~] = svmpredict(ones(numNuc,1), nucleiFeatures, cmodel,'-q');

lympCentroids=nucleiCentroids(LympPredict==1,:);
nonLympCentroids=nucleiCentroids(LympPredict==0,:);


%plot(lympCent(:,1),lympCent(:,2),'g*');
%plot(nonLympCent(:,1),nonLympCent(:,2),'r*');
imshow(M);
hold on;
plot(lympCentroids(:,1), lympCentroids(:,2), 'black*', 'MarkerSize',0.1);
hold off;
imgmark = insertMarker(image, [lympCentroids(:,1), lympCentroids(:,2)],'*','color','black','size',1);
imwrite(imgmark, [savpath 'imgs/testmemask.png']);
return
mskpoints=imread([testingFolder '/imgs/testmemask.png']);
bw5 = imcomplement(mskpoints);
bw6 = imfill(bw5,'holes')
imwrite(bw6,[testingFolder 'imgs/testmemask'],'-dpng');



% Save the .mat file for the file
save([testingFolder '15LympIdent.mat'], 'nucleiCentroids', 'lympCentroids', 'nonLympCentroids', 'LympPredict', 'nucleiFeatures');

drawNucleiCentroids(I,lympCentroids,nonLympCentroids, testingFolder);

