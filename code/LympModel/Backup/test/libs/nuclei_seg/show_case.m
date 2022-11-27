addpath(genpath('./veta_watershed'));
addpath(genpath('./GeneralLoG'));
addpath(genpath('./staining_normalization'));

%folder='C:\Users\German\Documents\Case\lymp_wsi_data\test\';
%image='29_38.png';

folder='C:\Users\German\Desktop\123\';
image='51_53_1_lym.png';
% IMData4SymmetricVoting_1={'8913.tif','8914.tif'};
% IMData4SymmetricVoting_1={'29_38.png'};

IMData4SymmetricVoting_1={[folder image]};

for i=1:length(IMData4SymmetricVoting_1)
%     curIMName=IMData4SymmetricVoting_1{i};
     curIM=imread(curIMName);
%     curIMsize=size(curIM);
%     [curIM_norm] = normalizeStaining(curIM);
%     curIM_normRed=curIM_norm(:,:,1);
curIM_normRed=curIM;

    %% using multi resolution watershed, speed up veta
    
%     p.scales=[4:2:6];
%     disp('begin nuclei segmentation using watershed');
%     [nuclei, properties] = nucleiSegmentationV2(curIM_normRed,p);
%     
%     [w,h,c]=size(curIM);
%     mask=zeros(w,h);
%     
%     figure;imshow(curIM);hold on;
%     for k = 1:length(nuclei)
%         
%         nuc=nuclei{k};
%         numPix=length(nuc);
%         for ind=1:numPix
%             mask(nuc(ind,1),nuc(ind,2))=255;
%         end
%         plot(nuclei{k}(:,2), nuclei{k}(:,1), 'g-', 'LineWidth', 2);
%     end
%     hold off;
%     %----Creating image---%
%     
%     mask = imfill(mask,'holes');
%     imwrite(mask,[folder image '_ws_mask.png']);
    
    
    %---------------------%
    
    %% using general LoG, in folder testIM_German/GeneralLoG
    %%% initial segmentation
    R=curIM_normRed; I=curIM;
    ac=30;    % remove isolated pixels(non-nuclei pixels)
    [Nmask,cs,rs,A3]=XNucleiSeg_GL_Thresholding(R,ac);      %% thresholding based binarization
%     show(Nmask);
    %%% gLoG seeds detection
    largeSigma=16;
    smallSigma=14; % Sigma value
    ns=XNucleiCenD_Clustering(R,Nmask,largeSigma,smallSigma);  %% To detect nuclei clumps
%     53 s
    figure(1),imshow(I);
    hold on,plot(ns(2,:),ns(1,:),'y+');
     hold on,plot(cs,rs,'y+');
%     hold on,plot(cs,rs,'g*');
    
    %%% marker-controlled watershed segmentation
%     ind=sub2ind(size(R),ns(1,:),ns(2,:));
%     bs4=zeros(size(R));
%     bs4(ind)=1;
%     [bnf,blm]=XWaterShed(Nmask,bs4);
    
    %%% show segmentations
%     bb=bwperim(Nmask);  % for debugging finial segmentations
%     ind5=find(bb);
%     blm(ind5)=1;
%     bb2=bwperim(A3);
%     ind6=find(bb2);
%     blm(ind6)=1;
%     overlay1=imoverlay(I,blm,[0 1 0]);
%     figure(2),imshow(overlay1);
end