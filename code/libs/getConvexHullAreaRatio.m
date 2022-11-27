function [convexHullAreaRatio, convexHullIntersectedArea, numLymInNonLympArea] = getConvexHullAreaRatio(lengthCentroids, filtcentroids, filtpreds, Kparameter)
% Function 6, 7, 10
% 6.  ConvexHullAreaRatio = √?rea de envoltura convexa no linfocitos / √?rea de envoltura convexa linfocitos, en un radio espec√≠fico
% 7.  ConvexHullIntersectedArea = √?rea de la intersecci√≥n de las envolturas conexas de los linfocitos y no linfocitos
% 10. numLymInNonLympArea = N√∫mero de linfocitos dentro de la envoltura convexa de los no-linfocitos
parfor k=1:length(Kparameter)
    for i=1:lengthCentroids
        centroidstemp = filtcentroids{k,i};
        predstemp = filtpreds{k,i};
        lymstemp = centroidstemp(find(predstemp ==1),:);
        nonlymstemp = centroidstemp(find(predstemp ==2),:);
        [xm,~] = size(lymstemp);
        [xq,~] = size(nonlymstemp);
        if isempty(lymstemp) || xm<=2
            ratioCellConvHullArea{k,i} = 0;
                lymInNonLympArea{k,i} = 0;
                ConvexHullIntersectedArea{k,i} = 0;
        else
            if isempty(nonlymstemp) || xq<=2
                ratioCellConvHullArea{k,i} = 0;
                lymInNonLympArea{k,i} = 0;
                ConvexHullIntersectedArea{k,i} = 0;
            else
                [chLymp,lympArea] = convhull(lymstemp);
                [chNonLymp ,nonLympArea] = convhull(nonlymstemp);
                ratioCellConvHullArea{k,i} = nonLympArea / lympArea;           
                %----------------- 7 --------------------------------------
                chLymp = lymstemp(chLymp,:);
                chNonLymp=nonlymstemp(chNonLymp,:);
                [xp1,yp1]=poly2cw(chLymp(:,1),chLymp(:,2));
                [xp2,yp2]=poly2cw(chNonLymp(:,1),chNonLymp(:,2));        
                [xi, yi] = polybool('intersection',xp1,yp1,xp2,yp2);
                ConvexHullIntersectedArea{k,i} = polyarea(xi,yi);
                %----------------- 10 -------------------------------------
                inNumLympArea = inpolygon(lymstemp(:,1),lymstemp(:,2),chNonLymp(:,1),chNonLymp(:,2));
                lymInNonLympArea{k,i}=sum(inNumLympArea);
                %----------------------------------------------------------
            end
        end
    end
end
ratioCellConvHullAreaTmp = cell2mat(ratioCellConvHullArea);
ConvexHullIntersectedAreaTmp = cell2mat(ConvexHullIntersectedArea);
numLymInNonLympAreaTmp = cell2mat(lymInNonLympArea);

convexHullAreaRatio = ratioCellConvHullAreaTmp';
convexHullIntersectedArea = ConvexHullIntersectedAreaTmp';
numLymInNonLympArea = numLymInNonLympAreaTmp';
end


