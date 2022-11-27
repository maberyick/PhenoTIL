function val = extractRatioAreaLympSample(nucleicentroids, totalAreaLymp, Kparameter, I)
% Function No. 3
% [L][extractRatioAreaLympSample] Total área linfocitos / �?rea de la muestra, en un radio específico
dL = 8; % Mean of a Lymphocyte Diameter
%I = imread(imgRoute);
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
        areasamp = sum(bw(:) == 0);
        ratiotemp= totalAreaLymp{k,i} / areasamp;
        if isnan(ratiotemp)
            ratiotemp = 0;
        end
        ratioAreaLympSample{k,i} = ratiotemp;
    end
end
ratioAreaLympSampleMat = cell2mat(ratioAreaLympSample);
val = ratioAreaLympSampleMat';
end