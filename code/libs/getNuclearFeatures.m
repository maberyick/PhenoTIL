function [centroids,localfeatures,locallabels,contextualfeatures,contextuallabels] = getNuclearFeatures( image,mask )

%GETNUCLEARFEATURES Extracts different features from nuclei.
addpath(genpath('/mnt/pan/Data7/crb138/DPGMM/FeatExt/ContextFeat'))

%mask2 = mask;

mask=mask(:,:,1);
mask = logical(mask);
mask = bwareaopen(mask, 30);
orderZernikePol=7;
grayImg=rgb2gray(image);


regionProperties = regionprops(mask,grayImg,'Centroid','Area',...
    'BoundingBox','Eccentricity','EquivDiameter','Image',...
    'MajorAxisLength','MaxIntensity','MeanIntensity','MinIntensity',...
    'MinorAxisLength','Orientation','PixelValues');

centroids = cat(1, regionProperties.Centroid);

%%%%%% Lines for checking the centroids
%mask2 = mask;
%imgmark = insertMarker(image, [centroids(:,1), centroids(:,2)],'*','color','blue','size',2);
%imgmark2 = insertMarker(mask2, [centroids(:,1), centroids(:,2)],'*','color','blue','size',2);
%imwrite(imgmark, '/mnt/data/home/crb138/Datasets/Breast_Cancer_Challenge/Feats/test.png')
%imwrite(imgmark2, '/mnt/data/home/crb138/Datasets/Breast_Cancer_Challenge/Feats/test2.png')
%pause
%%%%%%

medRed=[];
medGreen=[];
medBlue=[];
entropyRed=[];
medIntensity=[];
entropyIntensity=[];
harFeat=[];
edgeMedIntensity=[];
zernFeat=[];

nucleiNum=size(regionProperties,1);
for i=1:nucleiNum
    nucleus=regionProperties(i);
    bbox = nucleus.BoundingBox;
    bbox = [round(bbox(1)) round(bbox(2)) (bbox(3) - 1) (bbox(4) - 1)];
    roi = image(bbox(2) : bbox(2) + bbox(4), bbox(1) : bbox(1) + bbox(3), :);
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
    
    % Zernike moments
    [w,h]=size(nucleus.Image);
    sqRoi=getSquareRoi(grayImg,nucleus.Centroid,w,h);
    zernFeat=[zernFeat;getZernikeMomentsImg(sqRoi,orderZernikePol)];
end

ratioMedRB=medRed./medBlue;
ratioMedRG=medRed./medGreen;

ratioAxes=[regionProperties.MajorAxisLength]./[regionProperties.MinorAxisLength];

localfeatures = horzcat([regionProperties.Area]',[regionProperties.Eccentricity]', ...
    [regionProperties.EquivDiameter]',[regionProperties.Orientation]', ...
    ratioAxes',entropyIntensity,...
    double([regionProperties.MaxIntensity]'),medIntensity,...
    double([regionProperties.MinIntensity]'),edgeMedIntensity,entropyRed,...
    ratioMedRB,ratioMedRG,harFeat,zernFeat...
);

% Check the mean of the diameter of all nuclei of a image
%des = horzcat( [regionProperties.EquivDiameter]' );
%mean(des)

% Contextual Features
% Basic features regarding local information e.g. (area, ecc, intensity, quantity, distances)

[Kparameter, filtcentroids, filtareas, sumInvDistNuc, filtquantvarmat, filtareasvarmat, filtareasmeanmat, filtareasmedianmat,...
filtareasstdmat, filteccentricityvarmat, filteccentricitymeanmat, filteccentricitymedianmat, filteccentricitystdmat,...
filtdiametervarmat, filtdiametermeanmat, filtdiametermedianmat, filtdiameterstdmat, filtmeanIntensityvarmat,...
filtmeanIntensitymeanmat, filtmeanIntensitymedianmat, filtmeanIntensitystdmat, filtentropyRedvarmat,...
filtentropyRedmeanmat, filtentropyRedmedianmat, filtentropyRedstdmat, filtratioRedBbluevarmat, filtratioRedBbluemeanmat,...
filtratioRedBbluemedianmat, filtratioRedBbluestdmat, filtratioRedGreenvarmat,  filtratioRedGreenmeanmat,...
filtratioRedGreenmedianmat,  filtratioRedGreenstdmat] = getCentroidsByTresh(...
centroids, [regionProperties.Area]',[regionProperties.Eccentricity]',...
[regionProperties.EquivDiameter]',medIntensity,entropyRed,ratioMedRB,ratioMedRG...
);

ratioAreaNucSampleMat = extractRatioAreaNucSample(centroids, filtareas, Kparameter, image);

%%%%%% Lines for checking the centroids

%imgmark = insertMarker(image, [filtcentroids{3,600}(:,1), filtcentroids{3,600}(:,2)],'*','color','blue','size',10);
%imgmark2 = insertMarker(mask2, [filtcentroids{3,600}(:,1), filtcentroids{3,600}(:,2)],'*','color','blue','size',10);
%imwrite(imgmark, '/mnt/data/home/crb138/Datasets/Breast_Cancer_Challenge/Feats/test.png')
%imwrite(imgmark2, '/mnt/data/home/crb138/Datasets/Breast_Cancer_Challenge/Feats/test2.png')
%pause
%%%%%%

contextualfeatures = horzcat(sumInvDistNuc, ratioAreaNucSampleMat, filtquantvarmat, filtareasvarmat, filtareasmeanmat, filtareasmedianmat,...
filtareasstdmat, filteccentricityvarmat, filteccentricitymeanmat, filteccentricitymedianmat, filteccentricitystdmat,...
filtdiametervarmat, filtdiametermeanmat, filtdiametermedianmat, filtdiameterstdmat, filtmeanIntensityvarmat,...
filtmeanIntensitymeanmat, filtmeanIntensitymedianmat, filtmeanIntensitystdmat, filtentropyRedvarmat,...
filtentropyRedmeanmat, filtentropyRedmedianmat, filtentropyRedstdmat, filtratioRedBbluevarmat, filtratioRedBbluemeanmat,...
filtratioRedBbluemedianmat, filtratioRedBbluestdmat, filtratioRedGreenvarmat,  filtratioRedGreenmeanmat,...
filtratioRedGreenmedianmat,  filtratioRedGreenstdmat...
);

locallabels={'Area','Eccentricity','EquivDiameter','Orientation','ratioAxes','entropyIntensity',...
'MaxIntensity','medIntensity','MinIntensity','edgeMedIntensity','entropyRed','ratioMedRB ','ratioMedRG',...
'harFeat_energyAngularSecondMoment','harFeat_Contrast','harFeat_correlation','harFeat_Variance',...
'harFeat_InverseDifferenceMoment','harFeat_SumAverage','harFeat_SumVariance','harFeat_SumEntropy',...
'harFeat_Entropy','harFeat_DifferenceVariance','harFeat_DifferenceEntropy','harFeat_InformationMeasuresCorrelationI',...
'harFeat_InformationMeasuresCorrelationII','harFeat_MaximalCorrelationCoefficient','zernFeat1','zernFeat2',...
'zernFeat3','zernFeat4','zernFeat5','zernFeat6','zernFeat7','zernFeat8','zernFeat9','zernFeat10','zernFeat11',...
'zernFeat12','zernFeat13','zernFeat14','zernFeat15','zernFeat16','zernFeat17','zernFeat18','zernFeat19',...
'zernFeat20','zernFeat21','zernFeat22','zernFeat23','zernFeat24','zernFeat25','zernFeat26','zernFeat27',...
'zernFeat28','zernFeat29','zernFeat30','zernFeat31','zernFeat32','zernFeat33','zernFeat34','zernFeat35',...
'zernFeat36','zernFeat37','zernFeat38','zernFeat39','zernFeat40','zernFeat41','zernFeat42','zernFeat43',...
'zernFeat44','zernFeat45','zernFeat46','zernFeat47','zernFeat48','zernFeat49','zernFeat50','zernFeat51',...
'zernFeat52','zernFeat53','zernFeat54','zernFeat55','zernFeat56','zernFeat57','zernFeat58','zernFeat59',...
'zernFeat60','zernFeat61','zernFeat62','zernFeat63','zernFeat64','zernFeat65','zernFeat66','zernFeat67',...
'zernFeat68','zernFeat69','zernFeat70','zernFeat71','zernFeat72'};

contextuallabels={'sumInvDistNucK1','sumInvDistNucK2','sumInvDistNucK3',...
'ratioAreaNucSampleMatK1','ratioAreaNucSampleMatK2',...
'ratioAreaNucSampleMatK3','filtquantvarmatK1','filtquantvarmatK2','filtquantvarmatK3','filtareasvarmatK1',...
'filtareasvarmatK2','filtareasvarmatK3','filtareasmeanmatK1','filtareasmeanmatK2','filtareasmeanmatK3',...
'filtareasmedianmatK1','filtareasmedianmatK2','filtareasmedianmatK3','filtareasstdmatK1','filtareasstdmatK2',...
'filtareasstdmatK3','filteccentricityvarmatK1','filteccentricityvarmatK2','filteccentricityvarmatK3',...
'filteccentricitymeanmatK1','filteccentricitymeanmatK2','filteccentricitymeanmatK3','filteccentricitymedianmatK1',...
'filteccentricitymedianmatK2','filteccentricitymedianmatK3','filteccentricitystdmatK1','filteccentricitystdmatK2',...
'filteccentricitystdmatK3','filtdiametervarmatK1','filtdiametervarmatK2','filtdiametervarmatK3',...
'filtdiametermeanmatK1','filtdiametermeanmatK2','filtdiametermeanmatK3','filtdiametermedianmatK1',...
'filtdiametermedianmatK2','filtdiametermedianmatK3','filtdiameterstdmatK1','filtdiameterstdmatK2',...
'filtdiameterstdmatK3','filtmeanIntensityvarmatK1','filtmeanIntensityvarmatK2','filtmeanIntensityvarmatK3',...
'filtmeanIntensitymeanmatK1','filtmeanIntensitymeanmatK2','filtmeanIntensitymeanmatK3',...
'filtmeanIntensitymedianmatK1','filtmeanIntensitymedianmatK2','filtmeanIntensitymedianmatK3',...
'filtmeanIntensitystdmatK1','filtmeanIntensitystdmatK2','filtmeanIntensitystdmatK3','filtentropyRedvarmatK1',...
'filtentropyRedvarmatK2','filtentropyRedvarmatK3','filtentropyRedmeanmatK1','filtentropyRedmeanmatK2',...
'filtentropyRedmeanmatK3','filtentropyRedmedianmatK1','filtentropyRedmedianmatK2','filtentropyRedmedianmatK3',...
'filtentropyRedstdmatK1','filtentropyRedstdmatK2','filtentropyRedstdmatK3','filtratioRedBbluevarmatK1',...
'filtratioRedBbluevarmatK2','filtratioRedBbluevarmatK3','filtratioRedBbluemeanmatK1','filtratioRedBbluemeanmatK2',...
'filtratioRedBbluemeanmatK3','filtratioRedBbluemedianmatK1','filtratioRedBbluemedianmatK2',...
'filtratioRedBbluemedianmatK3','filtratioRedBbluestdmatK1','filtratioRedBbluestdmatK2','filtratioRedBbluestdmatK3',...
'filtratioRedGreenvarmatK1','filtratioRedGreenvarmatK2','filtratioRedGreenvarmatK3','filtratioRedGreenmeanmatK1',...
'filtratioRedGreenmeanmatK2','filtratioRedGreenmeanmatK3','filtratioRedGreenmedianmatK1',...
'filtratioRedGreenmedianmatK2','filtratioRedGreenmedianmatK3','filtratioRedGreenstdmat','filtratioRedGreenstdma2',...
'filtratioRedGreenstdma3'};
end

%---------------------------------------------------------------------------------%

function J=getSquareRoi(I,centroid,roiW,roiH)

[lim,~]=size(I);
len=max(roiW,roiH)/2;
x1=round(centroid(1)-len);
x2=round(centroid(1)+len);
y1=round(centroid(2)-len);
y2=round(centroid(2)+len);

w=x2-x1;
h=y2-y1;

if w>h
    y2=y2+1;
elseif h<w
    x2=x2+1;
end

J=uint8(zeros(x2-x1+1,x2-x1+1));

if x1<1
    x1=1;
end
if y1<1
    y1=1;
end

if y2>lim
    y2=lim;
end

if x2>lim
    x2=lim;
end

J(1:y2-y1+1,1:x2-x1+1)=I(y1:y2,x1:x2);

end


