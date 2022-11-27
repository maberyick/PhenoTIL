addpath(genpath('L:\codes\lymphocyteModelSVM\test'))

trainingFolder='data/training/';
testingFolder='data/testing/';

%% train a model here

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
model=trainSVMModel(featureMatrix(:,1:end-1),featureMatrix(:,end),kernel);

%% test the model here
I=imread([testingFolder '/imgs/29_38.png']);
M=getWatershedMask(I);

% --- Feature extraction --- %
[nucleiCentroids,nucleiFeatures,~]=getNucleiFeatures(I,M);

% --- Classification --- %
numNuc=length(nucleiFeatures);
[prediction,~,~] = svmpredict(ones(numNuc,1), nucleiFeatures, model,'-q');

lympCentroids=nucleiCentroids(prediction==1,:);
nonLympCentroids=nucleiCentroids(prediction==0,:);

drawNucleiCentroids(I,lympCentroids,nonLympCentroids);

