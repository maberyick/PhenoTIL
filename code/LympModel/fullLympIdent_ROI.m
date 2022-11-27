function fullLympIdent_ROI(foldnum)
% Add the paths
% do in order to solver missing problem: export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6
addpath(genpath('/mnt/pan/Data7/crb138/HistoCodes/LymphocyteModel'));
whlpath = '/mnt/pan/Data7/crb138/Datasets/Lung_UPN_Nivo/ROI_set/';
trainingFolder='/mnt/pan/Data7/crb138/HistoCodes/LymphocyteModel/data/training/';
testingFolder='/mnt/pan/Data7/crb138/HistoCodes/LymphocyteModel/data/testing/';
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
foldpathM = [whlpath 'CleanMasks/'];
foldpathT = [whlpath 'ROI/'];
foldsavpathL = [whlpath 'NucleiMasks/Lymp/'];
foldsavpathN = [whlpath 'NucleiMasks/nonLymp/'];
foldsavpathF = [whlpath 'NucleiMasks/nucFeats/'];
listing = dir(foldpathM);
dirFlags = [listing.isdir] & ~strcmp({listing.name},'.') & ~strcmp({listing.name},'..');
subFolders = listing(dirFlags);
ii = foldnum;
%for kk = 1 : length(subFolders)
for k = 1 : 1
    if exist([foldsavpathL subFolders(k).name]) ~= 7
        mkdir([foldsavpathL subFolders(k).name]);
        mkdir([foldsavpathN subFolders(k).name]);
        mkdir([foldsavpathF subFolders(k).name]);
    end
    maskfile = dir([foldpathM subFolders(k).name '/*.png']);
    nfile = length(maskfile);
    for jj=1:1
        tmleft = nfile - ii;
        fleft = length(subFolders) - k;
        curfile = maskfile(ii).name;
        fprintf('%d Left - %s Tile - %d Folder Left - In Folder %s \n',tmleft, maskfile(ii).name(1:end-18), fleft, subFolders(k).name);
       % Change for Tiles based
        if exist([foldsavpathF subFolders(k).name filesep maskfile(ii).name(1:end-18) '.mat'])
            fprintf('1st Skipping %s \n',maskfile(ii).name(1:end-18));
            continue
        elseif exist([foldpathT subFolders(k).name filesep maskfile(ii).name]) == 0
            fprintf('2nd Skipping %s \n',maskfile(ii).name(1:end-18));
            continue
        elseif exist([foldpathM subFolders(k).name filesep maskfile(ii).name]) == 0
            fprintf('3rd Skipping %s \n',maskfile(ii).name(1:end-18));
            continue
        end
%        if tmleft >= 19
%            continue
%        end
        imM = imread([foldpathM subFolders(k).name filesep maskfile(ii).name]);
        imT = imread([foldpathT subFolders(k).name filesep maskfile(ii).name]);
        [nucleiCentroids,nucleiFeatures,~]=getNucleiFeatures(imT,imM);
        numNuc=length(nucleiFeatures);
        if numNuc == 0
            fprintf('4th Skipping %s \n',maskfile(ii).name(1:end-18));
            continue
        end
        [LympPredict,~,~] = svmpredict(ones(numNuc,1), nucleiFeatures, cmodel,'-q');
        lympCentroids=nucleiCentroids(LympPredict==1,:);
        nonLympCentroids=nucleiCentroids(LympPredict==0,:);
        rndLymp = round(lympCentroids);
        rndnonLymp = round(nonLympCentroids);
        if length(rndLymp) == 0
            fprintf('5th Skipping %s \n',maskfile(ii).name(1:end-18));
            continue
        end
        bwLymp = bwselect(imM,rndLymp(:,1),rndLymp(:,2));
        bwnonLymp = bwselect(imM,rndnonLymp(:,1),rndnonLymp(:,2));
        imwrite(bwLymp, [foldsavpathL subFolders(k).name filesep maskfile(ii).name(1:end-18) '_L.png']);
        imwrite(bwnonLymp, [foldsavpathN subFolders(k).name filesep maskfile(ii).name(1:end-18) '_nonL.png']);
        save([foldsavpathF subFolders(k).name filesep maskfile(ii).name(1:end-18) '.mat'], 'nucleiCentroids', 'lympCentroids', 'nonLympCentroids', 'LympPredict', 'nucleiFeatures');
    end
end

disp('All done')