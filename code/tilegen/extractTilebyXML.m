function [polygonsCell, mask] = extractTilebyXML(xmlPath,imgPath)
    disp(xmlPath)
    disp(imgPath)
polygonsCell = {};
xDoc = xmlread(xmlPath);
polygons=xDoc.getElementsByTagName('Coordinates'); % get a list of all the region tags
xy = [];
%make sure the layer number for imread, small number might cause memory
%leakage if the image is too big
[~,~,extension] = fileparts(imgPath);
if issame(extension,'.tiff')
    pyramidLayer = 5;
elseif issame(extension,'.tif')
    pyramidLayer = 7;
elseif issame(extension,'.svs')
    pyramidLayer = 2;
end
imginfor = imfinfo(imgPath);
orgimsizeDim = round((imginfor(1).Height+imginfor(1).Width)/(imginfor(2).Height+imginfor(2).Width));
img = imread(imgPath,pyramidLayer);
figure('units','normalized','position',[1. 1. 1. 1.])
axes('Units', 'normalized', 'Position', [0 0 1 1])
axis vis3d equal; 
subplot(1,2,1)
imshow(img)
%setting the displaying location
pos = get(gca, 'Position');
pos(1) = 0.0;
pos(2) = 0.0;
pos(3) = .5;
pos(4) = 1;
set(gca, 'Position', pos)   
[a b] = size(img(:,:,1));
hold on,
for regioni = 0:polygons.getLength-1
    polygon=polygons.item(regioni);
    verticies=polygon.getElementsByTagName('Coordinate');
    xy = [];
    for vertexi = 0:verticies.getLength-1
        x=str2double(verticies.item(vertexi).getAttribute('X'));
        y=str2double(verticies.item(vertexi).getAttribute('Y'));
        xy = [xy;[x,y]]; % finally save them into the array
    end
    xy = [xy;xy(1,:)];
    polygonsCell = [polygonsCell;{xy}];
    hold on,
    %divided by corresponding zooming factor, refer to which layer the
    %image showing at
    if issame(extension,'.tiff')
        plot(xy(:,1)/(2^(pyramidLayer-1)),xy(:,2)/(2^(pyramidLayer-1)),'g*-','LineWidth',3);
    elseif issame(extension,'.tif')
        plot(xy(:,1)/(2^(pyramidLayer-3)),xy(:,2)/(2^(pyramidLayer-3)),'g*-','LineWidth',3);
    elseif issame(extension,'.svs')
        plot(xy(:,1)/orgimsizeDim,xy(:,2)/orgimsizeDim,'g*-','LineWidth',3);
    end    
end
    if issame(extension,'.tiff')
        mask = vertices2mask(polygonsCell,a,b,pyramidLayer,extension);
    elseif issame(extension,'.tif')
        mask = vertices2mask(polygonsCell,a,b,pyramidLayer,extension);
    elseif issame(extension,'.svs')
        mask = vertices2mask(gdivide(polygonsCell,{orgimsizeDim/2}),a,b,pyramidLayer,extension);
    end 
    subplot(1,2,2)
    imshow(mask)
    %setting the displaying location
    pos = get(gca, 'Position');
    pos(1) = 0.5;
    pos(2) = 0.0;
    pos(3) = 0.5;
    pos(4) = 1;
    set(gca, 'Position', pos)    
    
    [~,fname,~] = fileparts(xmlPath);
%     print([fname,'.png'],'-dpng','-r10')
end


function BWLast = vertices2mask(polygonsCell,a,b,pyramidLayer,extension)
BWLast = zeros(a,b);
if issame(extension,'.tiff')
    pyramidLayer_factor = pyramidLayer-1;
elseif issame(extension,'.tif')
    pyramidLayer_factor = pyramidLayer-3;
elseif issame(extension,'.svs')
    pyramidLayer_factor = pyramidLayer-1;
end
for i = 1:length(polygonsCell)
    BW = double(poly2mask(polygonsCell{i}(:,1)/(2^(pyramidLayer_factor)),polygonsCell{i}(:,2)/(2^(pyramidLayer_factor)),a,b));
    BWLast = BWLast+BW;    
    BWLast(BWLast~=1) = 0;
end
end