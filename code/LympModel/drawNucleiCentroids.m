function drawNucleiCentroids(image,lympCent,nonLympCent, savpath)

plot(lympCent(:,1),lympCent(:,2),'g*');
plot(nonLympCent(:,1),nonLympCent(:,2),'r*');

imgmark = insertMarker(image, [lympCent(:,1), lympCent(:,2)],'*','color','blue','size',2);
imgmark2 = insertMarker(imgmark, [nonLympCent(:,1),nonLympCent(:,2)],'*','color','red','size',2);

imwrite(imgmark2, [savpath 'imgs/testme.png']);


hold off;
end