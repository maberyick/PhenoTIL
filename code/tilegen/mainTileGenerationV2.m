function mainTileGenerationV2(varargin)
    %function mainTileGenerationV2 (ImageDataPath, ImageWSIPath, save_folder, imgformat)
    %EXTRACTALLTILFEATURES Extracts the full set of TIL-based features from
    %either TMAs or WSIs.
    %% Paths
    %addpath('/home/gxc206/scripts/libs/nuclei_seg/staining_normalization/');
    %addpath('/home/gxc206/scripts/libs/nuclei_seg/veta_watershed/');
    %addpath('/home/gxc206/scripts/libs/');
    %addpath('/home/gxc206/scripts/libs/zernike/');
    
    %folder='/home/gxc206/imgs/Nivo/';
    placeholder = 'placeholder';

    ImageDataPath = varargin{1};
    ImageWSIPath = varargin{2};
    save_folder = varargin{3};
    imgformat = varargin{4};
    %tissuequal = varargin{5};
    tissuequal = 0.4;
    xmlFiles = dir([ImageDataPath '*.xml']);
    xmlNames = {xmlFiles.name};
    imgFiles = dir([ImageWSIPath,'*.',imgformat]); %made for TIFF format format
    imgNames = {imgFiles.name};
    try        
        mkdir(save_folder)
        mkdir([save_folder '/mat_tiles/'])
        mkdir([save_folder '/snapshot/'])
    catch
        disp('mask dir already exist')
    end

    count1 = 0;
for i = 1:length(xmlNames)
    %name = imgNames{i}(5:end);
    %idx = contains(xmlNames,name);
    %Index = find(idx==true);
    nameStruct = [xmlNames{i}(1:end-3),'mat'];
    if exist([save_folder '/mat_tiles/' nameStruct],'file')~=2
        save([save_folder '/mat_tiles/' nameStruct],'placeholder');
        count1 = count1 + 1;
        fprintf('Working at case %s \n',xmlNames{i}(1:end-3));
        % try this for ASAP annotation
        [polygonsCell, mask] = extractTilebyXML([ImageDataPath,xmlNames{i}],[ImageWSIPath,xmlNames{i}(1:end-3),imgformat]);
        % try this for HistoView annotation
        %[polygonsCell, mask] = extractTilebyXML_histo([ImageDataPath,xmlNames{i}],[ImageWSIPath,xmlNames{i}(1:end-3),imgformat]);
        close all
        if issame(imgformat,'tiff')
            pyramidLayer = 5;
            stepsize = 2000/(2^3);
        elseif issame(imgformat,'tif')
            pyramidLayer = 7;
            stepsize = 2000/(2^3);
        elseif issame(imgformat,'svs')
            pyramidLayer = 2;
            imginfor = imfinfo([ImageWSIPath,xmlNames{i}(1:end-3),imgformat]);
            orgimsizeDim = (imginfor(1).Height+imginfor(1).Width)/(imginfor(2).Height+imginfor(2).Width);
            %stepsize = 4000/(orgimsizeDim);
            stepsize = 2000/(orgimsizeDim);
        end
        stepsize = round(stepsize);
        img = imread([ImageWSIPath,xmlNames{i}(1:end-3),imgformat],pyramidLayer);
        %% visualization with grid
        imshow(img.*uint8(mask))
        for idxR = stepsize:stepsize:size(mask,1)
            line([0 size(mask,2)],[idxR idxR])
        end
        for idxC = stepsize:stepsize:size(mask,2)
            line([idxC idxC],[0 size(mask,1)])
        end
        f = getframe(gcf);
        new = f.cdata;
        %% Tiles in ROI
%         figure
        ImgMat = [];count2 = 0; count3 = 0;
        for idxR = stepsize:stepsize:size(mask,1)
            for idxC = stepsize:stepsize:size(mask,2)
               count3 = count3+1;
               fprintf('Total: %d - Row: %d -Column: %d - Clean Tiles: %d - Count: %d \n',length(stepsize:stepsize:size(mask,1))*length(stepsize:stepsize:size(mask,2)), idxR,idxC,count2, count3)
                % Add a metric for at least 30% of tissue content is
                % segmented
                try
                    [mska,mskb] = size(mask(idxR:idxR+stepsize,idxC:idxC+stepsize));
                    dd = sum(sum(mask(idxR:idxR+stepsize,idxC:idxC+stepsize)))/(mska*mskb);
                    if dd>tissuequal
                        tissextrc = 1;
                    else
                        tissextrc = 0;
                    end
                catch
                        tissextrc = 0;
                end
                if idxR+stepsize < size(mask,1) && idxC+stepsize < size(mask,2) && tissextrc
                    count2 = count2 + 1;
                    slidePtr = openslide_open([ImageWSIPath,xmlNames{i}(1:end-3),imgformat]);
                    info = imfinfo([ImageWSIPath,xmlNames{i}(1:end-3),imgformat]);
                    if issame(imgformat,'tiff')
                        TileTargetReso = imread([ImageWSIPath,xmlNames{i}(1:end-3),imgformat],2,...
                        'PixelRegion',{[idxR*2^3,idxR*2^3+1999],[idxC*2^3,idxC*2^3+1999]});
                        saveName = [xmlNames{i}(1:end-4),'_layer_2','_size_',num2str(info(2).Height),'_',num2str(info(2).Width),...
                            '_row_',num2str(idxR*2^3),'_col_',num2str(idxC*2^3),'.png'];          
                    elseif issame(imgformat,'tif')
                        TileTargetReso = imread([ImageWSIPath,xmlNames{i}(1:end-3),imgformat],4,...
                        'PixelRegion',{[idxR*2^3,idxR*2^3+1999],[idxC*2^3,idxC*2^3+1999]});
                        saveName = [xmlNames{i}(1:end-4),'_layer_2','_size_',num2str(info(4).Height),'_',num2str(info(4).Width),...
                            '_row_',num2str(idxR*2^3),'_col_',num2str(idxC*2^3),'.png'];          
                    elseif issame(imgformat,'svs')
                        row1 = idxR*orgimsizeDim;colm1 = idxC*orgimsizeDim;                       
                        %row1 = idxR*2^3; row2 = idxR*2^3+1999; colm1 = idxC*2^3; colm2 = idxC*2^3+1999;
                        % Change between 1 or 0, need to find the level with most pixels
                        %TileTargetReso = openslide_read_region(slidePtr,colm1,row1,4000,4000,'level',0);
                        TileTargetReso = openslide_read_region(slidePtr,colm1,row1,2000,2000,'level',0);
                        TileTargetReso = TileTargetReso(:,:,2:4);
                        saveName = [xmlNames{i}(1:end-4),'_layer_2','_size_',num2str(info(2).Height),'_',num2str(info(2).Width),...
                            '_row_',num2str(idxR*2^3),'_col_',num2str(idxC*2^3),'.png'];          
                    end
                    tileStruct(count2).data = TileTargetReso;
                    tileStruct(count2).name = saveName;
%                     close all
                end
            end
        end
        tileStruct(1).snapshot = new;
%        imwrite(new,['Z:\data\CCF\Lung\subsetCT\',xmlNames{i}(1:end-3),'png'])
        imwrite(new,[save_folder '/snapshot/',xmlNames{i}(1:end-3),'png'])
        nameStruct = [xmlNames{i}(1:end-3),'mat'];
%        save(['Z:\data\CCF\Lung\subsetCT\',nameStruct],'tileStruct')
%       try
%            save([save_folder '/mat_tiles/',nameStruct],'tileStruct');
%       catch
%            disp('File larger than 2Gb, saving with matlab 7.3 format')
%            save([save_folder '/mat_tiles/',nameStruct],'tileStruct', '-v7.3');
%       end
        save([save_folder '/mat_tiles/',nameStruct],'tileStruct', '-v7.3');
        clear tileStruct
        clear new
        close all
    end
end
disp('all done here')
