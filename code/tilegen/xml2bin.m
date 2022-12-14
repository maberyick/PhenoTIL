function xml2bin(varagin)
ImageWSIPath = 'D:\Dataset\SCLC\wsi\';
%% Prepare Masks for DL model
clc;
clear all;
pth_xml = 'D:\Dataset\SCLC\tumor_xmlannotations\';
pth_img = 'D:\Dataset\SCLC\tumor_matpatches\snapshot\';
pth_svh = 'D:\Dataset\SCLC\tumor_binmask\';
folderContents = dir([pth_xml '*.xml']);
numFiles=length(folderContents);
for k=1:numFiles
    [~, filename, ~] = fileparts(folderContents(k).name);
    mkdir ([pth_svh filename]); mkdir ([pth_svh filename '/masks']); mkdir ([pth_svh filename '/images']);
    copyfile([pth_img filename '.png'], [pth_svh filename '/images']);
    xml_file = [pth_xml filename '.xml']; img_file = [pth_img filename '.png'];
    xy = ext_xml(xml_file);
    [wratio, hratio, nrow, ncol] = ext_img(img_file);
    %mask_full=zeros(nrow,ncol); %pre-allocate a mask
    for zz=1:length(xy) %for each region
        mask_single=zeros(nrow,ncol); %pre-allocate a mask
        smaller_x=xy{zz}(:,1)*wratio; %down sample the region using the ratio
        smaller_y=xy{zz}(:,2)*hratio;
        mask_single=mask_single+poly2mask(smaller_x,smaller_y,nrow,ncol); %make a mask and add it to the current mask
        % save the single masks
        imwrite(mask_single,[pth_svh filename '/masks/' filename '_nuc' num2str(zz) '.png'])
        %mask_full=mask_single+poly2mask(smaller_x,smaller_y,nrow,ncol);
    end
    % save the original mask
    %imwrite(mask_full,[pth_svh filename '/masks/' filename '.png'])    
end
disp('done')
%% TESTING PURPOSES
figure;
hold all;
set(gca,'YDir','reverse'); %invert y axis
for zz=1:length(xy)
    plot(xy{zz}(:,1),xy{zz}(:,2),'LineWidth',12)
end
%%
svsinfo=imfinfo(img_file);
s=1; %base level of maximum resolution
s2=1; % down sampling of 1:32
hratio=svsinfo(s2).Height/svsinfo(s).Height;  %determine ratio
wratio=svsinfo(s2).Width/svsinfo(s).Width;
nrow=svsinfo(s2).Height;
ncol=svsinfo(s2).Width;
mask_single=zeros(nrow,ncol); %pre-allocate a mask
for zz=1:length(xy) %for each region
    smaller_x=xy{zz}(:,1)*wratio; %down sample the region using the ratio
    smaller_y=xy{zz}(:,2)*hratio;
    mask_single=mask_single+poly2mask(smaller_x,smaller_y,nrow,ncol); %make a mask and add it to the current mask
    %this addition makes it obvious when more than 1  layer overlap each
    %other, can be changed to simply an OR depending on application.
end
%%
io=imread(img_file,'Index',s2);
subplot(1,2,1)
imshow(io)
subplot(1,2,2)
imshow(mask_single)
end
