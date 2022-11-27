function [intenDifMedianTotal ,sumDistLymptoNonLymp] = getIntensityDifferenceMedian(lengthcentroids, nucleiCentroids, filtcentroids, MeanIntensity, filtintensities, filtpreds, Kparameter)
% Function No.5 y 11
% Mediana de la diferencia cuadrada de las intensidades, en un radio específico.
% Suma de la distancia entre el linfocito y los no-linfocitos

for k=1:length(Kparameter)
    for i=1:lengthcentroids
        intensitytemp = filtintensities{k,i};
        centroidtemp = filtcentroids{k,i};
        predstemp = filtpreds{k,i};
        intetemp = intensitytemp(find(predstemp ==1),:);
        nonlymptemp = centroidtemp(find(predstemp ==2),:);  
        lympArray=[nucleiCentroids(i,:);nonlymptemp];
        distmp=squareform(pdist(lympArray));
        if isempty(distmp)
            sumDistLymptoNonLymp{k,i}=0;
        else
            sumDistLymptoNonLymp{k,i}=sum(distmp(:,1));
        end
        if isempty(intetemp)
            intenDifMedian{k,i} = 0;
        else
            intenDifMedian{k,i} = median((MeanIntensity(i)-intetemp).^2);
        end
    end
end
intenDifMediantemp = cell2mat(intenDifMedian); 
sumDistLymptoNonLymptemp = cell2mat(sumDistLymptoNonLymp);

intenDifMedianTotal = intenDifMediantemp';
sumDistLymptoNonLymp = sumDistLymptoNonLymptemp';
end
