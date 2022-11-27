function[ratioLymp, totalAreaLymp, ratioNumLympNonLymp] = extractRatioAreaLympNonLymp(filtcentroids,filtareas, filtpreds, Kparameter)
% Function No. 2 and No. 4
%[A][extractRatioAreaLympNonLymp] Total suma área linfocitos / Total suma área no-linfocitos, en un radio específico
% [A][extractRatioNumLympNonLymp] Numero de linfocitos / numero
% no-linfocitos, en un radio especifico

% Extract the areas and predictions
sizeNuclei = size(filtcentroids);
lengthNuclei = sizeNuclei(2);

for k=1:length(Kparameter)
    for i=1:lengthNuclei
        tempArea = filtareas{k,i};
        tempPred = filtpreds{k,i};
        sumLymp = sum(tempArea(find(tempPred==1),:));
        sumNonLymp = sum(tempArea(find(tempPred==2),:));
        countLymp = sum(tempPred==1);
        countNonLymp = sum(tempPred==2);
        if sumNonLymp==0
            sumNonLymp=1;
        end        
        if countNonLymp==0
            countNonLymp=0.1;
        end        
        totalAreaLymp{k,i} = sumLymp;
        ratioLympNonLymptemp = sumLymp / sumNonLymp;
        ratioNumNucleitemp = countLymp / countNonLymp;
        ratioLympNonLymp{k,i} = ratioLympNonLymptemp;
        ratioNumNuclei{k,i} = ratioNumNucleitemp;
    end
end
% ratioLymp... = columns are the k radious, row are the nuclei value
%ratioLympNonLymp(:,K)
ratioLympNonLympMat = cell2mat(ratioLympNonLymp);
ratioNumLympNonLympMat = cell2mat(ratioNumNuclei);
ratioLymp = ratioLympNonLympMat';
ratioNumLympNonLymp = ratioNumLympNonLympMat';
end