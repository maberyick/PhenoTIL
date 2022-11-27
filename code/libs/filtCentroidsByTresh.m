function [filtcentroids, filtareas, filtintensities, filtpreds, Kparameter] = filtCentroidsByTresh(nucleiCentroids, MeanIntensity, nucleiArea, nucleiPrediction)
% Filtering the nuclei by a treshold (centroids and area)
dist = pdist(nucleiCentroids);
dist = dist.^-1;
dL = 8; % Mean of a Lymphocyte Diameter
Kparameter = [5,10,15]; % Radious to be multiplied with dL
concParam = [nucleiCentroids nucleiArea MeanIntensity nucleiPrediction]; % unite the parameters to be fitlered
% a matrix for each of the three
for i=1:length(Kparameter)
    thresh = 1/(dL*Kparameter(i));
    eval(['matrxK' num2str(Kparameter(i)) '= squareform(dist);']);
end

%       remove the values lower (farest from a atom) from the matrix based on a
%       thhreshold = 8 is the diameter of a lympb (mean) and multiply by 5
%       to give a radious of cluster

for k=1:length(Kparameter)
    thresh = 1/(dL*Kparameter(k));
    eval([ 'tempMatrx = matrxK' num2str(Kparameter(k)) ';' ]);
    tempMatrx(tempMatrx<thresh) = 0;
    eval([ 'matrxK' num2str(Kparameter(k)) '= tempMatrx;']);
end

% Filt each of the nuclei,area,pred on each centroid

for k=1:length(Kparameter)
    for j=1:length(nucleiCentroids)
        filtcent = []; filtarea = []; filtintensity = []; filtpred = [];
        eval([ 'tempMatrx = matrxK' num2str(Kparameter(k)) ';' ]);
        tempMatrx(j,j) = 1;
        pos = find(tempMatrx(:, j:j));
        for i=1:length(pos)
            % save in filt the filtered 'centroids' and 'area' from the cells
            filtcent = [filtcent; concParam(pos(i),1:2)];
            filtarea = [filtarea; concParam(pos(i),3:3)];
            filtintensity = [filtintensity; concParam(pos(i),4:4)];
            filtpred = [filtpred; concParam(pos(i),5:5)];
        end
        % filtcentroids, filtareas, filtpreds are saved as cells of 1 x alpha where
        % alpha is the quantity of nuclei within a radious, each cell contains the centroids; to
        % extract use centroid_x = filtcentroids{ 1, x}
        filtcentroids{k,j} = filtcent;
        filtareas{k,j} = filtarea;
        filtintensities{k,j} = filtintensity;
        filtpreds{k,j} = filtpred;
    end
end
end