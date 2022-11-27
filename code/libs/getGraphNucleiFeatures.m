function [graphNucleiFeatures] = getGraphNucleiFeatures(nucleiCentroids, nucleiArea, MeanIntensity, nucleiPrediction, image)

% extracts the nuclei that are near to each centroid by using a threshold
[filtcentroids, filtareas, filtintensities, filtpreds, Kparameter] = filtCentroidsByTresh(nucleiCentroids, MeanIntensity, nucleiArea, nucleiPrediction);
%  Structure of filts variables:
% K x T cell, where T = quantity of nuclei; K = thresholds of 5dL, 10dL, 15dL;
% dL = mean of a diameter of a Lymp.(8px at 40X);
% inside a cell = array of the filteres nuclei by each specific radious 

%  [Nuclei x K1 K2 K3]

% Function No. 1
sumInvDistLymp = extractSumInvDistLymp(nucleiCentroids, Kparameter);

% Function No. 2 y 4
[RatioAreaLympNonLymp,  totalAreaLymp, ratioNumLympNonLymp] = extractRatioAreaLympNonLymp(filtcentroids, filtareas, filtpreds, Kparameter);

% Function No. 3
ratioAreaLympSample = extractRatioAreaLympSample(nucleiCentroids, totalAreaLymp, Kparameter, image);

% Function No. 5, 11
[intensityDifferenceMedian, sumDistLymptoNonLymp] = getIntensityDifferenceMedian(length(nucleiCentroids), nucleiCentroids, filtcentroids, MeanIntensity, filtintensities,filtpreds, Kparameter);

% Function No. 6, 7 , 10
[convexHullAreaRatio, convexHullIntersectedArea, numLymInNonLympArea] = getConvexHullAreaRatio(length(nucleiCentroids), filtcentroids, filtpreds, Kparameter);

% Function No. 8 y 9
[mediamDistLympNonLympNeig, ratioMediamDistLympNonLympNeig] = extractMediamDistLympToNonLympNeig(nucleiCentroids, filtcentroids, filtpreds, Kparameter);

% Function No. 12
areaSample= extractAreaSample(nucleiCentroids, Kparameter, image);

% all the features extracted
graphNucleiFeatures = [sumInvDistLymp RatioAreaLympNonLymp ratioAreaLympSample ratioNumLympNonLymp intensityDifferenceMedian convexHullAreaRatio convexHullIntersectedArea mediamDistLympNonLympNeig ratioMediamDistLympNonLympNeig numLymInNonLympArea sumDistLymptoNonLymp areaSample];
%graphNucleiLabels = {'sumInvDistLymp', 'RatioAreaLympNonLymp', 'ratioAreaLympSample', 'ratioNumLympNonLymp', 'intensityDifferenceMedian', 'convexHullAreaRatio', 'convexHullIntersectedArea', 'mediamDistLympNonLympNeig', 'ratioMediamDistLympNonLympNeig', 'numLymInNonLympArea', 'sumDistLymptoNonLymp', 'areaSample'};
end