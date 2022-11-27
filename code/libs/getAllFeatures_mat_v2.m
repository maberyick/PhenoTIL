clear all; clc;
%add the paths
addpath(genpath('/home/maberyick/MEGA/main_ResDev/Projects/pj_clusterAnalysisTMA_V1/FeatExt/zernike/'));
addpath(genpath('/home/maberyick/MEGA/main_ResDev/Projects/pj_clusterAnalysisTMA_V1/FeatExt/nuclei_seg/'));
addpath(genpath('/home/maberyick/MEGA/main_ResDev/Projects/pj_clusterAnalysisTMA_V1/FeatExt/'));

placeholder = 'placeholder';
% Test
imgsDir = '/media/maberyick/MABELOCAL/Wdataset/YTMA79_IHF/YTMA_image_fixed_V2/';
maskDir = '/media/maberyick/MABELOCAL/Wdataset/YTMA79_IHF/markers_HEQIF_V1/';
saveDir = '/media/maberyick/MABELOCAL/Wdataset/YTMA79_IHF/featExt_HE_V2/';

%imgl= imread(imgsDir);
%mskLl= imread(maskDir);
%msknonLl = imread(masknonDir);

gathimgs = dir([imgsDir '*png']);

for a = 1:length(gathimgs)
    imgp = [imgsDir gathimgs(a).name];
    [~, name, ~] = fileparts(imgp);
    % load the .mat file with lymp info
    findnum = sscanf(name, 'YTMA79-10_%d');
    mutfil = load([maskDir 'cdx_markers_' num2str(findnum) '.mat']);
    mskLl = mutfil.lym_mask;
    msknonLl = (~mutfil.lym_mask).*(mutfil.he_mask);
    if exist([saveDir name '.mat'])
        disp('Feat already exists')
        continue
    end
    disp(['Extracting Features from Image ' name]);
    imgl = imread(imgp);
    % OPTIONAL Extract general features from Lymphocytes Only
    %[centroids,localFeatures,localLabels,contextFeatures,contextualLabels] = getNuclearFeatures(imgl,mskl);
    % Extract TIL % nonTIL Interplay features
    save([saveDir name '.mat'],'placeholder')
    [centroids_L,centroids_nonL,localFeatures_L,localLabels_L,contextFeatures_L,contextualLabels_L,graphInterplayFeatures,graphInterplayLabels] = getNuclearFeaturesPlay(imgl,mskLl,msknonLl);
    % Save the Lymphocyte based features (Lymp and nonLymp Interplay)
    save([saveDir name '.mat'], 'centroids_L','centroids_nonL','localFeatures_L','localLabels_L','contextFeatures_L','contextualLabels_L','graphInterplayFeatures','graphInterplayLabels');
    % Save the Nuclei based Features OPTIONAL
    %save([save2Dir name '.mat'], 'centroids','localFeatures','localLabels','contextFeatures','contextualLabels');
    % Local Feats from 1 to 99
    % Contextual Feats from 100 to 190
end