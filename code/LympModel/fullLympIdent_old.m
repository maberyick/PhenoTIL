function fullMaskClean(whlpath)
addpath(genpath('/mnt/data/home/crb138/HistoCodes/LymphocyteModel'));
foldpath = [whlpath 'Masks/'];
foldsavpath = [whlpath 'CleanMasks/'];
listing = dir(foldpath);
dirFlags = [listing.isdir] & ~strcmp({listing.name},'.') & ~strcmp({listing.name},'..');
subFolders = listing(dirFlags);
for k = 1 : length(subFolders)
    mkdir([foldsavpath subFolders(k).name]);
    maskfile = dir([foldpath subFolders(k).name '/*.png']);
    nfile = length(maskfile);
    for ii=1:nfile
        tmleft = nfile - ii;
        fleft = length(subFolders) - k;
        fprintf('%d Left - %s Tile - %d Folder Left - In Folder %s \n',tmleft, maskfile(ii).name, fleft, subFolders(k).name);
        %Load the mas
        curfile = maskfile(ii).name;
        if exist([foldsavpath subFolders(k).name filesep maskfile(ii).name])
            continue
        end
        im = imread([foldpath subFolders(k).name filesep maskfile(ii).name]);
        % Load the Tile
        %orgfile = imgfile(ii).name;
        %orgim = imread([pathorg orgfile]);
        % Adjust the contrast
        %im = adapthisteq(im);
        % Remove the nuclei on the border (cut off nuclei)
        im = imclearborder(im);
        % remove noise by a filter (change matrix accordingly)
        %im = wiener2(im,[3 3]);
        % get the image into binary
        bw = im2bw(im, graythresh(im)*0.7);
        % fill the nuclei that are not completely solid
        bw = imfill(bw,'holes');
        % then do a opening with a disk (change disk size accordinly)
        bw = imopen(bw, strel('disk',3));
        % remove the images smaller than certain pixels (30 pixels)
        bw = bwareaopen(bw, 35);
        % Try to divide the bigger chunk of nuclei into single nucleus
        D = -bwdist(~bw);
        mask = imextendedmin(D,0.5);
        D2 = imimposemin(D, mask);
        Ld2 = watershed(D2);
        bw(Ld2 == 0) = 0;
        % Remove again smaller pieces
        bw = bwareaopen(bw, 35);
        %Write the final clean mask image
        imwrite(bw,[foldsavpath subFolders(k).name filesep maskfile(ii).name]);
    end
end