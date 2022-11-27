function [R] = parimgbox_simple(image, bbox)
    roi = image(bbox(2) : bbox(2) + bbox(4), bbox(1) : bbox(1) + bbox(3),:);
    R=roi(:,:,1);
end