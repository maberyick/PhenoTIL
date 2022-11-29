# import libraries
# Run on the python 2.7
# conda create --name py2 python=2.7
# install old version of skleran and numpy
# pip install numpy==1.16.4
# pip install "scikit-learn==0.19.0"
# pip install pillow
# pip install pandas
# pip install matplotlib
# pip install sio
from __future__ import division
import sklearn.externals.joblib as extjoblib
import joblib
import glob
# import pickle
from sklearn.preprocessing import MinMaxScaler
import scipy.io as sio
import numpy as np
import ntpath
import collections
import os
import re
# import pandas as pd
# import matplotlib.pyplot as plt
#import seaborn as sns
# from PIL import ImageOps
#from skimage.color import rgb2hed, rgb2gray
# Load the normalization scaler
scaler = extjoblib.load('./data/phenoTIL/scale/clusterLCS_Scale.pickle')
# Load the trained module
dpgmm = joblib.load('./data/phenoTIL/dpgmm/clusterLCS_8_v2.pickle')
# Path for saving the clustered images
pathtest_save = './output/test_cls.mat'
pathtest_set = './data/features_mat/test_set/test.mat'
# Load the set
test_files = glob.glob(pathtest_set)
# generate the clusters
mat_T = sio.loadmat(pathtest_set)
cent_T = mat_T['centroids_L']
L_T = mat_T['localFeatures_L']
C_T = mat_T['contextFeatures_L']
S_T = mat_T['graphInterplayFeatures']
feat_T = np.hstack((L_T,C_T,S_T))
naNs_val = np.isnan(feat_T)
feat_T[naNs_val] = 0
infs_val = np.isinf(feat_T)
feat_T[infs_val] = 0
print(np.shape(feat_T))
M_norm = scaler.transform(feat_T)
T_X = dpgmm.predict(M_norm)
fildmp = {'c_features':feat_T, 'c_centroids':cent_T, 'cluspred':T_X}
sio.savemat(pathtest_save, fildmp)
print('all done')