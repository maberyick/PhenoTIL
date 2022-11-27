function drawNucleiCentroids(image,lympCent,nonLympCent)

imshow(image);
hold on;

plot(lympCent(:,1),lympCent(:,2),'g*');
plot(nonLympCent(:,1),nonLympCent(:,2),'r*');


hold off;
end