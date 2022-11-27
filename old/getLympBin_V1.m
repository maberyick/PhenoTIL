function getLympBin_V1(varargin)
placeholder = 'placeholder';
imgsDir_pt = varargin{1};
imgsDir_ls = dir(imgsDir_pt);
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
        [mskLl,msknonLl, isLymphocyte, nucleiCentroids, lympCentroids, nonLympCentroids] = getLympMask_V2(imgl);
        % Save the Lymphocyte based features (Lymp and nonLymp)
        save_spiephen_par_V2(svmatp, mskLl, msknonLl, isLymphocyte, nucleiCentroids, lympCentroids, nonLympCentroids);
    end
end
end