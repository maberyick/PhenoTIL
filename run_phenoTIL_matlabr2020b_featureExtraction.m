%%% PhenoTIL feature script for MATLAB
%%% by Cristian Barrera
%%% 11/20/22
%%%
%%% It includes:
%%% Nuclei segmentation using the Watershed approach by Mitko Veta
%%% Lymphocyte identification usinb German Corredor approach
%%% 288 feature vector phenotyping the identified lymphocytes
%%%
% Add the current path
addpath(genpath('./code'))

% We run the following example on H&E sample image
% load the image
img = imread('./data/test_set/test.png');

% we run the phenoTIL script
% save the sample features as a mat file
input_path = './data/test_set/'; % all the H&E patches as png
output_path = './output/matlab/';
getAllFeatures_V2(input_path,output_path);
%%
% To get the mask we can simply run it as
nuclei = getWatershedMask(img,1,4,12);
% Save the mask
imwrite(nuclei,'./output/test.png')
% To get the lymphocytes from the nuclei mask and image we run it as
% load the trained lymphocyte model
lympModel = load('lymp_svm_matlab_wsi.mat');
lympModel = lympModel.model;
% Extract local (shape, size, intensity) features
[nucleiCentroids,feat_simplenuclei] = get_localcellfeatures(img,nuclei);
% Identify which is lymphocyte and which is not
isLymphocyte = (predict(lympModel,feat_simplenuclei(:,1:7)))==1;
% Identify the centroids of lymphocytes and non-lymphocytes
lympCentroids=nucleiCentroids(isLymphocyte==1,:);
nonLympCentroids=nucleiCentroids(isLymphocyte~=1,:);
% Represent them as a binary mask
rndLymp = round(lympCentroids);
rndnonLymp = round(nonLympCentroids);
bwLymp = bwselect(nuclei,rndLymp(:,1),rndLymp(:,2));
bwnonLymp = bwselect(nuclei,rndnonLymp(:,1),rndnonLymp(:,2));
% save the lymphocyte mask
imwrite(bwLymp,'./output/matlab/test_lymp.png')
imwrite(bwnonLymp,'./output/matlab/test_nonlymp.png')

% Plot and save how the example looks like
FigH = figure('Position', get(0, 'Screensize'));
subplot(2,2,1);
imshow(img)
title('H&E Sample')
subplot(2,2,3);
imshow(nuclei)
title('Identified nuclei')
subplot(2,2,[2 4]);
imshow(img)
hold on
scatter(lympCentroids(:,1),lympCentroids(:,2),'*g');
scatter(nonLympCentroids(:,1),nonLympCentroids(:,2),'*r');
hold off
title('Lymphocyte identification (green=lymphocyte)')
F = getframe(FigH);
imwrite(F.cdata, './output/matlab/test_result.png', 'png')

% Extract the phenoTIL features
