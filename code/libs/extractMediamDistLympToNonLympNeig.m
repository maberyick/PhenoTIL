function [ mediamDistLympNonLympNeig, ratioMediamDistLympNonLympNeig] = extractMediamDistLympToNonLympNeig(nucleicentroids, filtcentroids, filtpreds, Kparameter)
% No. 8 y 9
% [A][extractMediamDistLympToNonLympNeig] Mediana de las distancias entre
% cada linfocito y su vecino no-linfocito mas cercano, en un radio
% especifico
% Mediana de la distancia minima entre linfocitos / Mediana de la distancia
% minima entre un linfocito y su vecino no-linfocito

for k=1:length(Kparameter)
    for i=1:length(nucleicentroids)
        centroidCurr = nucleicentroids(i,:);
        xc = centroidCurr(1); yc =  centroidCurr(2);
        centroidstemp = filtcentroids{k,i};
        predstemp = filtpreds{k,i};
        lymstemp = centroidstemp(find(predstemp ==1),:);
        lymsnontemp = centroidstemp(find(predstemp ==2),:);
        listDistanNL = []; listDistanLL = [];
        [lymstempLength, ~]= size(lymstemp);
            if isempty(lymstemp) || isempty(lymsnontemp)
                listDistanLL = [listDistanLL, 0];
                listDistanNL = [listDistanNL, 0];
            else
                for m=1:lymstempLength
                    centrme = lymstemp(m,:);
                    lymstempCen = lymstemp;
                    lymstempCen(m,:) = [];
                    xc = centrme(1); yc = centrme(2);
                    % d is the distance and p is the location in the array
                    % min Lymp to a nonLymp
                    [dnL,pnL] = min((lymsnontemp(:,1)-xc).^2 + (lymsnontemp(:,2)-yc).^2);
                    % min Lymp to a Lymp
                    [dLL,pLL] = min((lymstempCen(:,1)-xc).^2 + (lymstempCen(:,2)-yc).^2);
                    dnL = sqrt(dnL);
                    dLL = sqrt(dLL);
                    listDistanNL = [listDistanNL, dnL];
                    listDistanLL = [listDistanLL, dLL];
                end
            end
        MedianNLTemp = median( listDistanNL);
        MedianLLTemp = median( listDistanLL);
        listMedianDist{k,i} = MedianNLTemp;
        tempdiv = MedianLLTemp / MedianNLTemp;
        if isnan(tempdiv)
            listMedianDistRatio{k,i} = 0;
        else
           listMedianDistRatio{k,i} = tempdiv;
        end
    end
end
mediamDistTemp = cell2mat(listMedianDist);
ratioMediamDistTemp = cell2mat(listMedianDistRatio);

mediamDistLympNonLympNeig = mediamDistTemp';
ratioMediamDistLympNonLympNeig = ratioMediamDistTemp';
end