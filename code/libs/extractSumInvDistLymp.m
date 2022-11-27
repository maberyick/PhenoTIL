function val= extractSumInvDistLymp(lympCentroids, Kparameter)
% Function No. 1
% [L][extractSumInvDistLymp] Suma del inverso de las distancias entre linfocitos, en un radio específico
%       calculate the distance between atoms and invert them to see farest as low
%       value and closest as high value
dist = pdist(lympCentroids);
dist = dist.^-1;
%       calculate the matrix of the pdist, which compares each atom to all the
%       others
matrxK5 = squareform(dist);
matrxK10 = squareform(dist);
matrxK15 = squareform(dist);
% Normilize by div the matrix to 1000, to avoid larger numbers
% if want to use a more local measurement or per image matrx = matrx / 1000.0
% matrx = matrx/1000.0;
%       remove the values lower (farest from a atom) from the matrix based on a
%       thhreshold = 8 is the diameter of a lympb (mean) and multiply by 5
%       to give a radious of cluster
dL = 8; % Mean of a Lymphocyte Diameter

threshK5  = 1/(dL*Kparameter(1));
threshK10 = 1/(dL*Kparameter(2));
threshK15 = 1/(dL*Kparameter(3));

matrxK5(matrxK5<threshK5) = 0;
matrxK10(matrxK10<threshK10) = 0;
matrxK15(matrxK15<threshK15) = 0;
 %       sum the resulting columns of the matrix
matrxSumK5 = sum(matrxK5);
matrxSumK10 = sum(matrxK10);
matrxSumK15 = sum(matrxK15);

%       Invert row to columns
val= [matrxSumK5(:) matrxSumK10(:) matrxSumK15(:)];
end