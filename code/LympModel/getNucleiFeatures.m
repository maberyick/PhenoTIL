function [nucleiCentroids,nucleiFeatures,labels]=getNucleiFeatures(image,mask)
mask=logical(mask(:,:,1));
mask = bwareaopen(mask, 30);
image=normalizeStaining(image);
grayImg=rgb2gray(image);
[msk_a,~] = size(mask); [gry_a,~] = size(grayImg); msk_len = gry_a - msk_a;
if ~isequal(size(mask), size(grayImg))
    mask = padarray(mask,[msk_len/2 msk_len/2]);
end
regionProperties = regionprops(mask, grayImg, 'Centroid', 'Area', 'Perimeter', 'Eccentricity', 'MinorAxisLength', ...
    'MajorAxisLength', 'Extent', 'Orientation','MaxIntensity','MinIntensity','Image','BoundingBox');
nucleiCentroids = cat(1, regionProperties.Centroid);
medRed=[];
entr=[];
nucleiNum=size(regionProperties,1);
parfor i=1:nucleiNum
    nucleus=regionProperties(i);
    bbox = nucleus.BoundingBox;
    bbox = [round(bbox(1)) round(bbox(2)) (bbox(3) - 1) (bbox(4) - 1)];
    roi = image(bbox(2) : bbox(2) + bbox(4), bbox(1) : bbox(1) + bbox(3), :);
    R=roi(:,:,1);
    R=R(nucleus.Image == 1);    
    medRed = [medRed;median(double(R))];
    entr=[entr; getNucEntropy(R)];
end
longness=[regionProperties.MajorAxisLength]./[regionProperties.MinorAxisLength];
nucleiFeatures = horzcat([regionProperties.Area]',[regionProperties.Eccentricity]', ...
    longness',medRed,...
    entr,double([regionProperties.MinIntensity]'),double([regionProperties.MaxIntensity]')...
);

labels={'Area','Eccentricity', ...
    'Major Axis / Minor Axis','Median Red',...
    'Entropy','MinIntensity', 'MaxIntensity'
    };
end

