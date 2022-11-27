function fullLympIdent_TMA(varargin)
% Add the paths
% do in order to solver missing problem: export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6
whlpath = varargin{1};
trainingFolder='./data/training/';
% Train the Model
folderContents = dir([trainingFolder '/imgs/*.png']);
numFiles=length(folderContents);
featureMatrix=[];
for k=1:numFiles
    [~, filename, ~] = fileparts(folderContents(k).name);
    featVectorLymp=getFeatureVector(trainingFolder,filename,'lymp');
    featVectorNonLymp=getFeatureVector(trainingFolder,filename,'other');
    featureMatrix=[featureMatrix;featVectorLymp;featVectorNonLymp];
end
kernel=0;
cmodel=trainSVMModel(featureMatrix(:,1:end-1),featureMatrix(:,end),kernel);
foldpathM = [whlpath 'Masks/'];
foldpathT = [whlpath 'TMAs/'];
foldsavpathL = [whlpath 'NucleiMasks/Lymp/'];
foldsavpathN = [whlpath 'NucleiMasks/nonLymp/'];
foldsavpathF = [whlpath 'NucleiMasks/nucFeats/'];
%for kk = 1 : length(subFolders)
if exist([foldsavpathL]) ~= 7
    mkdir([foldsavpathL]);
    mkdir([foldsavpathN]);
    mkdir([foldsavpathF]);
end
maskfile = dir([foldpathM '/*.png']);
nfile = length(maskfile);
parfor ii=1:nfile
    tmleft = nfile - ii;
    if isfile([foldsavpathL maskfile(ii).name])
         continue
    end
    fprintf('%d Left - %s Tile \n',tmleft, maskfile(ii).name(1:end-4));
    try
        imM = imread([foldpathM filesep maskfile(ii).name]);
        imT = imread([foldpathT filesep maskfile(ii).name]);
    catch
        continue
    end
    [nucleiCentroids,nucleiFeatures,~]=getNucleiFeatures(imT,imM);
    numNuc=length(nucleiFeatures);
    [LympPredict,~,~] = svmpredict(ones(numNuc,1), nucleiFeatures, cmodel,'-q');
    lympCentroids=nucleiCentroids(LympPredict==1,:);
    nonLympCentroids=nucleiCentroids(LympPredict==0,:);
    rndLymp = round(lympCentroids);
    rndnonLymp = round(nonLympCentroids);
    bwLymp = bwselect(imM,rndLymp(:,1),rndLymp(:,2));
    bwnonLymp = bwselect(imM,rndnonLymp(:,1),rndnonLymp(:,2));
    imwrite(bwLymp, [foldsavpathL maskfile(ii).name]);
    imwrite(bwnonLymp, [foldsavpathN maskfile(ii).name]);
    parsave_lym([foldsavpathF filesep maskfile(ii).name(1:end-9) '.mat'], 'nucleiCentroids', 'lympCentroids', 'nonLympCentroids', 'LympPredict', 'nucleiFeatures');
end

disp('All done')