function getAllFeatures_V2(varargin)
placeholder = 'placeholder';
% Test
imgsDir_pt = varargin{1};
imgsDir_ls = dir(imgsDir_pt);
%maskLDir = varargin{2};
%masknonLDir = varargin{3};
saveDir = varargin{2};
Index = randperm(numel(imgsDir_ls), length(imgsDir_ls));
for b=3:length(imgsDir_ls)
    bb = Index(b);
    imgsDir = [imgsDir_pt imgsDir_ls(bb).name '/'];
    gathimgs = dir([imgsDir '*png']);
    savefold = [saveDir imgsDir_ls(bb).name '/'];
    mkdir(savefold);
    parfor a=1:length(gathimgs)
        % stablish the paths
        imgp = [imgsDir gathimgs(a).name];
        svmatp = [savefold gathimgs(a).name(1:end-4) '.mat'];
        [~, name, ~] = fileparts(imgp);
        %mskL = [maskLDir name '.png'];
        %msknonL = [masknonLDir name '.png'];
        if exist(svmatp,'file')==2
            disp('Feat already exists')
            continue
        end
        disp(['Extracting Features from Image ' name]);
        save_plc(svmatp,placeholder);
        imgl = imread(imgp);    
        % Generate the lymphocyte mask
        [mskLl,msknonLl] = getLympMask(imgl);
        [centroids_L,centroids_nonL,localFeatures_L,localLabels_L,contextFeatures_L,contextualLabels_L,graphInterplayFeatures,graphInterplayLabels] = getNuclearFeaturesPlay(imgl,mskLl,msknonLl);
        % Save the Lymphocyte based features (Lymp and nonLymp Interplay)
        save_spiephen_par(svmatp, centroids_L,centroids_nonL,localFeatures_L,localLabels_L,contextFeatures_L,contextualLabels_L,graphInterplayFeatures,graphInterplayLabels);
    end
end
end