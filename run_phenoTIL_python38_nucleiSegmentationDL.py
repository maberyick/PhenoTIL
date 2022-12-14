import os
import sys
import tensorflow as tf
sys.path.insert(0, './code/python')
import utils_mod as utils
from PIL import Image
import numpy as np
import h5py
import tensorflow.compat.v1 as tf
tf.disable_v2_behavior()

FLAGS = tf.compat.v1.flags.Flag

# Variable arguments
image_path = sys.argv
output_path = sys.argv

run_config = tf.compat.v1.ConfigProto()
run_config.gpu_options.allow_growth = True
sess = tf.Session(config=run_config)
flags = FLAGS
model = utils.net_arch(sess, flags, (2000,2000))
saver = tf.train.Saver()
sess.run(tf.global_variables_initializer())
model_out_dir = "model"
if utils.load_model(sess, saver, model_out_dir):
    best_auc_sum = sess.run(model.best_auc_sum)
    print('====================================================')
    print(' Best auc_sum: {:.3}'.format(best_auc_sum))
    print('=============================================')
    print(' [*] Load Success!\n')
names = utils.all_files_under('/home/maberyick/CCIPD_Research/Github/PhenoTIL_V1/data/test_set/','.png')
for name in names:
    print(name)
    savingName = '/home/maberyick/CCIPD_Research/Github/PhenoTIL_V1/output/python/' + os.path.basename(name)[:-4] + '_mask'
    if os.path.isfile(savingName) or os.path.getsize(name)>>20 < 2:
        print('size less than 2MB or file existed , continue to next')
        continue       

    image = Image.open(name)
    print(np.shape(image))
    image = image.resize((2000,2000), Image.ANTIALIAS)
    print('predicting on image ', name)
    image = np.expand_dims(image, axis=0)
    print(np.shape(image))
    samples = sess.run(tf.get_default_graph().get_tensor_by_name('g_/Sigmoid:0'), \
            feed_dict={tf.get_default_graph().get_tensor_by_name('image:0'): image})
    samples = np.squeeze(samples*255).astype(np.uint8)        
    hdf5 = h5py.File(savingName,mode='w')
    hdf5.create_dataset('mask', data = samples)
    hdf5.close()
    print(np.shape(samples))
    print(type(samples))
    print(samples.shape)
    image = Image.fromarray(samples)
    image.save(savingName+"_dl.png")