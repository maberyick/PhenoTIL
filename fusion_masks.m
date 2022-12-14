img = imread('/home/maberyick/CCIPD_Research/Github/PhenoTIL_V1/data/test_set/test.png');
BW_ml = imread('/home/maberyick/CCIPD_Research/Github/PhenoTIL_V1/output/matlab/test_mask_ml.png');
BW = imread('/home/maberyick/CCIPD_Research/Github/PhenoTIL_V1/output/python/test_mask_dl.png');
BW = imbinarize(BW,'adaptive');
BW = bwareaopen(BW, 30);
BW = bwpropfilt(BW,'Area',[0 200]);

BW_comb = BW + logical(BW_ml);
imwrite(BW_comb,'/home/maberyick/CCIPD_Research/Github/PhenoTIL_V1/output/python/test_mask_combined.png');
figure, imshow(BW)




imshowpair(BW,BW2,'montage')


