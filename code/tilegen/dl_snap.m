function dl_snap(varargin)
    %% Generate the patches for the a DL model
    %% Involves, the lower level of the WSI and the tumour annotated regions based on ASAP    
    ImageXmlPath = varargin{1};
    ImageWSIPath = varargin{2};
    save_folder = varargin{3};
    imgformat = varargin{4};
    xmlFiles = dir([ImageXmlPath '*.xml']);
    xmlNames = {xmlFiles.name};
    imgFiles = dir([ImageWSIPath,'*.',imgformat]); %made for TIFF format format
    imgNames = {imgFiles.name};
    try        
        mkdir(save_folder)
        mkdir([save_folder '/annotation/'])
        mkdir([save_folder '/snapshot/'])
    catch
        disp('mask dir already exist')
    end
for i = 1:length(xmlNames)
    %name = imgNames{i}(5:end);
    %idx = contains(xmlNames,name);
    %Index = find(idx==true);
    nameStruct = [xmlNames{i}(1:end-3),'png'];
    if exist([save_folder '/annotation/' nameStruct],'file')~=2
        fprintf('Working at case %s \n',xmlNames{i}(1:end-3));
        % try this for ASAP annotation
        [~, mask] = extractTilebyXML([ImageXmlPath,xmlNames{i}],[ImageWSIPath,xmlNames{i}(1:end-3),imgformat]);
        % try this for HistoView annotation
        %[polygonsCell, mask] = extractTilebyXML_histo([ImageDataPath,xmlNames{i}],[ImageWSIPath,xmlNames{i}(1:end-3),imgformat]);
        if issame(imgformat,'tiff')
            pyramidLayer = 5;
        elseif issame(imgformat,'tif')
            pyramidLayer = 7;
        elseif issame(imgformat,'svs')
            pyramidLayer = 2;
            imginfor = imfinfo([ImageWSIPath,xmlNames{i}(1:end-3),imgformat]);
            orgimsizeDim = (imginfor(1).Height+imginfor(1).Width)/(imginfor(2).Height+imginfor(2).Width);
        end
        img = imread([ImageWSIPath,xmlNames{i}(1:end-3),imgformat],pyramidLayer);
        %% visualization with grid
        %masked_reg = img.*uint8(mask);
        imwrite(img,[save_folder '/snapshot/',xmlNames{i}(1:end-3),'png']);
        imwrite(mask,[save_folder '/annotation/',xmlNames{i}(1:end-3),'png']);
        close all;        
    end
end
disp('all done here')
end
