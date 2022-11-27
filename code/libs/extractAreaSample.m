function areaSampleMat = extractAreaSample(nucleicentroids, Kparameter, I)
% Function No. 12
% [L][extractAreaSample] Total features from the centroids to K radio sample. 
dL = 8; % Mean of a Lymphocyte Diameter
imageSize = size(I);
% a matrix for each of the three 
for k=1:length(Kparameter)
    rad = Kparameter(k)*dL;
    for i=1:length(nucleicentroids)
        centroidNuclei = nucleicentroids(i,:);
        xx = centroidNuclei(1); yy =  centroidNuclei(2);
        ci = [xx, yy, rad];     % center and radius of the circle ([c_row, c_col, r])
        [X,Y] = ndgrid((1:imageSize(1))-ci(2),(1:imageSize(2))-ci(1));
        mask = uint8((X.^2 + Y.^2)<ci(3)^2);
        croppedImage = uint8(zeros(size(I)));
        croppedImage(:,:,1) = I(:,:,1).*mask;
        croppedImage(:,:,2) = I(:,:,2).*mask;
        croppedImage(:,:,3) = I(:,:,3).*mask;
        croptemp = croppedImage;
        M = repmat(all(~croptemp,3),[1 1 3]); %mask black parts
        croptemp(M) = 255; %turn them white
        bw = im2bw(croptemp,graythresh(I));
        bw = ~bw;
        bw = bwareaopen(bw, 1000);
        bw = bwareaopen(~bw, 100);
        bw = ~bw;
        croptemp_gs = rgb2gray(croptemp);
        regionProperties = regionprops(bw,croptemp_gs,'Area',...
            'BoundingBox','Image','MaxIntensity','MeanIntensity','MinIntensity');
        medRed=[]; medGreen=[]; medBlue=[]; entropyRed=[]; medIntensity=[];
        entropyIntensity=[]; harFeat=[]; edgeMedIntensity=[];
        nucleiNum=size(regionProperties,1);
        for j=1:nucleiNum
            nucleus=regionProperties(j);
            bbox = nucleus.BoundingBox;
            bbox = [round(bbox(1)) round(bbox(2)) (bbox(3)-1) (bbox(4)-1)];
            roi = croptemp(bbox(2):bbox(2)+bbox(4),bbox(1):bbox(1)+bbox(3),:);
            per = bwperim(nucleus.Image);
            gray=rgb2gray(roi);
            R=roi(:,:,1);
            G=roi(:,:,2);
            B=roi(:,:,3);    
            R=R(nucleus.Image == 1);
            G=G(nucleus.Image == 1);
            B=B(nucleus.Image == 1);
            grayPix=gray(nucleus.Image == 1);
            perPix=gray(per==1);
            % Intensity features:
            medRed = [medRed;median(double(R))];
            medGreen = [medGreen;median(double(G))];
            medBlue = [medBlue;median(double(B))];
            medIntensity=[medIntensity;median(double(grayPix))];
            edgeMedIntensity=[edgeMedIntensity;median(double(perPix))];
            % Texture features:
            % Entropies
            entropyRed=[entropyRed; getNucEntropy(R)];
            entropyIntensity=[entropyIntensity;getNucEntropy(grayPix)];
            % Haralick features
            glcm = graycomatrix(gray);
            harFeat=[harFeat;haralickTextureFeatures(glcm,1:14)'];
        end
        ratioMedRB=medRed./medBlue; ratioMedRG=medRed./medGreen;
        regionFeatures = horzcat([regionProperties.Area]', ...
            entropyIntensity,double([regionProperties.MaxIntensity]'), ...
            medIntensity,double([regionProperties.MinIntensity]'), ...
            edgeMedIntensity,entropyRed,ratioMedRB,ratioMedRG,harFeat...
            );
        [rgnfetsize,~] = size(regionFeatures);
        if rgnfetsize > 1
             regionFeatures = mean(regionFeatures);
        end
        if rgnfetsize == 0
             regionFeatures = [zeros(1,23)];
        end
        if isnan(regionFeatures)
             regionFeatures = [zeros(1,23)];
        end       
        areaSample{k,i} = regionFeatures;
    end
end
areaSamplecel = areaSample';
areaSampleMat = cell2mat(areaSamplecel);
end