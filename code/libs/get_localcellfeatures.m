function [ centroids,features] = get_localcellfeatures(image, mask)
%GETNUCLOCALFEATURES Summary of this function goes here
%   Detailed explanation goes here
mask = logical(mask);
mask = bwareaopen(mask, 30);
image=normalizeStaining(image);
grayImg=rgb2gray(image);
regionProperties = regionprops(mask,grayImg,'Centroid','Area',...
    'BoundingBox','Eccentricity','EquivDiameter','Image',...
    'MajorAxisLength','MaxIntensity','MeanIntensity','MinIntensity',...
    'MinorAxisLength','Orientation','PixelValues');
centroids = cat(1, regionProperties.Centroid);
medRed=[];
entropyRed=[];
nucleiNum=size(regionProperties,1);
parfor i=1:nucleiNum
    nucleus=regionProperties(i);
    bbox = nucleus.BoundingBox;
    bbox = [round(bbox(1)) round(bbox(2)) (bbox(3) - 1) (bbox(4) - 1)];
    %roi = image(bbox(2) : bbox(2) + bbox(4), bbox(1) : bbox(1) + bbox(3), :);
    [R] = parimgbox_simple(image, bbox);
    %R=roi(:,:,1);
    R=R(nucleus.Image == 1);
    % Intensity features:
    medRed = [medRed;median(double(R))];
    % Entropies
    entropyRed=[entropyRed; getNucEntropy(R)];    
end
ratioAxes=[regionProperties.MajorAxisLength]./[regionProperties.MinorAxisLength];

features = horzcat([regionProperties.Area]',[regionProperties.Eccentricity]', ...
    ratioAxes',medRed,entropyRed,double([regionProperties.MinIntensity]'),...
    double([regionProperties.MaxIntensity]'));
end

