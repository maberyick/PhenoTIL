function fullMask_TMA(varargin)
whlpath = varargin{1};
foldpathM = [whlpath 'Masks/'];
foldpathT = [whlpath 'TMAs/'];
%for kk = 1 : length(subFolders)
if exist([foldpathM]) ~= 7
    mkdir([foldpathM]);
end
maskfile = dir([foldpathT '/*.png']);
nfile = length(maskfile);
parfor ii=1:nfile
    tmleft = nfile - ii;
    if isfile([foldpathM maskfile(ii).name])
         continue
    end
    fprintf('%d Left - %s Tile \n',tmleft, maskfile(ii).name(1:end-4));
    try
        imT = imread([foldpathT filesep maskfile(ii).name]);
    catch
        continue
    end
    % put true if image is not color normalized
    NMask=getWatershedMask(imT,true,6,12);
    imwrite(NMask, [foldpathM maskfile(ii).name]);
end
disp('All done')