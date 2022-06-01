function getAllFeatures(varargin)
placeholder = 'placeholder';
% Test
imgsDir = varargin{1};
maskLDir = varargin{2};
masknonLDir = varargin{3};
saveDir = varargin{4};
gathimgs = dir([imgsDir '*png']);
parfor a=1:length(gathimgs)
    imgp = [imgsDir gathimgs(a).name];
    [~, name, ~] = fileparts(imgp);
    mskL = [maskLDir name '.png'];
    msknonL = [masknonLDir name '.png'];
    if exist([saveDir name '.mat'],'file')==2
        disp('Feat already exists')
        continue
    elseif exist([maskLDir name '.png'],'file') == 0
        disp('Lymp mask does not exist')
        continue
    elseif exist([masknonLDir name '.png'],'file') == 0
        disp('non-Lymp mask does not exist')
        continue   
    end
    disp(['Extracting Features from Image ' name]);
    imgl = imread(imgp);
    mskLl = imread(mskL);
    msknonLl = imread(msknonL);
    save_plc([saveDir name '.mat'],placeholder);
    [centroids_L,centroids_nonL,localFeatures_L,localLabels_L,contextFeatures_L,contextualLabels_L,graphInterplayFeatures,graphInterplayLabels] = getNuclearFeaturesPlay(imgl,mskLl,msknonLl);
    % Save the Lymphocyte based features (Lymp and nonLymp Interplay)
    save_spiephen_par([saveDir name '.mat'], centroids_L,centroids_nonL,localFeatures_L,localLabels_L,contextFeatures_L,contextualLabels_L,graphInterplayFeatures,graphInterplayLabels);
end
end