import numpy as np
import tensorflow.compat.v1 as tf
from tensorflow.python.training import moving_averages
from tensorflow.python.tools.inspect_checkpoint import print_tensors_in_checkpoint_file
import os
import cv2
import h5py


def load_model(sess, saver, model_out_dir):
    print(' [*] Reading checkpoint...')

    ckpt = tf.train.get_checkpoint_state(model_out_dir)
    if ckpt and ckpt.model_checkpoint_path:
        ckpt_name = os.path.basename(ckpt.model_checkpoint_path)
        latest_ckp = tf.train.latest_checkpoint(model_out_dir)        
        saver.restore(sess, os.path.join(model_out_dir, ckpt_name))
      
        
def net_arch(sess, flags, image_size):
        sess = sess
        flags = flags
        image_size = image_size

        _gen_train_ops, _dis_train_ops = [], []
        gen_c, dis_c = 32, 32
      
        X = tf.placeholder(tf.float32, shape=[None, *image_size, 3], name='image')
        Y = tf.placeholder(tf.float32, shape=[None, *image_size, 1], name='vessel')
 
        g_samples = generator(X, gen_c, _gen_train_ops)

def generator(data, gen_c, _gen_train_ops, name='g_'):
    with tf.variable_scope(name):
        # conv1: (N, 640, 640, 1) -> (N, 320, 320, 32)
        conv1 = conv2d(data, gen_c, k_h=3, k_w=3, d_h=1, d_w=1, name='conv1_conv1')
        conv1 = batch_norm(conv1, name='conv1_batch1', _ops=_gen_train_ops)
        conv1 = tf.nn.relu(conv1, name='conv1_relu1')
        conv1 = conv2d(conv1, gen_c, k_h=3, k_w=3, d_h=1, d_w=1, name='conv1_conv2')
        conv1 = batch_norm(conv1, name='conv1_batch2', _ops=_gen_train_ops)
        conv1 = tf.nn.relu(conv1, name='conv1_relu2')
        pool1 = max_pool_2x2(conv1, name='maxpool1')

        # conv2: (N, 320, 320, 32) -> (N, 160, 160, 64)
        conv2 = conv2d(pool1, 2*gen_c, k_h=3, k_w=3, d_h=1, d_w=1, name='conv2_conv1')
        conv2 = batch_norm(conv2, name='conv2_batch1', _ops=_gen_train_ops)
        conv2 = tf.nn.relu(conv2, name='conv2_relu1')
        conv2 = conv2d(conv2, 2*gen_c, k_h=3, k_w=3, d_h=1, d_w=1, name='conv2_conv2')
        conv2 = batch_norm(conv2, name='conv2-batch2', _ops=_gen_train_ops)
        conv2 = tf.nn.relu(conv2, name='conv2_relu2')
        pool2 = max_pool_2x2(conv2, name='maxpool2')

        # conv3: (N, 160, 160, 64) -> (N, 80, 80, 128)
        conv3 = conv2d(pool2, 4*gen_c, k_h=3, k_w=3, d_h=1, d_w=1, name='conv3_conv1')
        conv3 = batch_norm(conv3, name='conv3_batch1', _ops=_gen_train_ops)
        conv3 = tf.nn.relu(conv3, name='conv3_relu1')
        conv3 = conv2d(conv3, 4*gen_c, k_h=3, k_w=3, d_h=1, d_w=1, name='conv3_conv2')
        conv3 = batch_norm(conv3, name='conv3_batch2', _ops=_gen_train_ops)
        conv3 = tf.nn.relu(conv3, name='conv3_relu2')
        pool3 = max_pool_2x2(conv3, name='maxpool3')

        # conv4: (N, 80, 80, 128) -> (N, 40, 40, 256)
        conv4 = conv2d(pool3, 8*gen_c, k_h=3, k_w=3, d_h=1, d_w=1, name='conv4_conv1')
        conv4 = batch_norm(conv4, name='conv4_batch1', _ops=_gen_train_ops)
        conv4 = tf.nn.relu(conv4, name='conv4_relu1')
        conv4 = conv2d(conv4, 8*gen_c, k_h=3, k_w=3, d_h=1, d_w=1, name='conv4_conv2')
        conv4 = batch_norm(conv4, name='conv4_batch2', _ops=_gen_train_ops)
        conv4 = tf.nn.relu(conv4, name='conv4_relu2')
        pool4 = max_pool_2x2(conv4, name='maxpool4')

        # conv5: (N, 40, 40, 256) -> (N, 40, 40, 512)
        conv5 = conv2d(pool4, 16*gen_c, k_h=3, k_w=3, d_h=1, d_w=1, name='conv5_conv1')
        conv5 = batch_norm(conv5, name='conv5_batch1', _ops=_gen_train_ops)
        conv5 = tf.nn.relu(conv5, name='conv5_relu1')
        conv5 = conv2d(conv5, 16*gen_c, k_h=3, k_w=3, d_h=1, d_w=1, name='conv5_conv2')
        conv5 = batch_norm(conv5, name='conv5_batch2', _ops=_gen_train_ops)
        conv5 = tf.nn.relu(conv5, name='conv5_relu2')

        # conv6: (N, 40, 40, 512) -> (N, 80, 80, 256)
        up1 = upsampling2d(conv5, size=(2, 2), name='conv6_up')
        conv6 = tf.concat([up1, conv4], axis=3, name='conv6_concat')
        conv6 = conv2d(conv6, 8*gen_c, k_h=3, k_w=3, d_h=1, d_w=1, name='conv6_conv1')
        conv6 = batch_norm(conv6, name='conv6_batch1', _ops=_gen_train_ops)
        conv6 = tf.nn.relu(conv6, name='conv6_relu1')
        conv6 = conv2d(conv6, 8*gen_c, k_h=3, k_w=3, d_h=1, d_w=1, name='conv6_conv2')
        conv6 = batch_norm(conv6, name='conv6_batch2', _ops=_gen_train_ops)
        conv6 = tf.nn.relu(conv6, name='conv6_relu2')

        # conv7: (N, 80, 80, 256) -> (N, 160, 160, 128)
        up2 = upsampling2d(conv6, size=(2, 2), name='conv7_up')
        conv7 = tf.concat([up2, conv3], axis=3, name='conv7_concat')
        conv7 = conv2d(conv7, 4*gen_c, k_h=3, k_w=3, d_h=1, d_w=1, name='conv7_conv1')
        conv7 = batch_norm(conv7, name='conv7_batch1', _ops=_gen_train_ops)
        conv7 = tf.nn.relu(conv7, name='conv7_relu1')
        conv7 = conv2d(conv7, 4*gen_c, k_h=3, k_w=3, d_h=1, d_w=1, name='conv7_conv2')
        conv7 = batch_norm(conv7, name='conv7_batch2', _ops=_gen_train_ops)
        conv7 = tf.nn.relu(conv7, name='conv7_relu2')

        # conv8: (N, 160, 160, 128) -> (N, 320, 320, 64)
        up3 = upsampling2d(conv7, size=(2, 2), name='conv8_up')
        conv8 = tf.concat([up3, conv2], axis=3, name='conv8_concat')
        conv8 = conv2d(conv8, 2*gen_c, k_h=3, k_w=3, d_h=1, d_w=1, name='conv8_conv1')
        conv8 = batch_norm(conv8, name='conv8_batch1', _ops=_gen_train_ops)
        conv8 = tf.nn.relu(conv8, name='conv8_relu1')
        conv8 = conv2d(conv8, 2*gen_c, k_h=3, k_w=3, d_h=1, d_w=1, name='conv8_conv2')
        conv8 = batch_norm(conv8, name='conv8_batch2', _ops=_gen_train_ops)
        conv8 = tf.nn.relu(conv8, name='conv8_relu2')

        # conv9: (N, 320, 320, 64) -> (N, 640, 640, 32)
        up4 = upsampling2d(conv8, size=(2, 2), name='conv9_up')
        conv9 = tf.concat([up4, conv1], axis=3, name='conv9_concat')
        conv9 = conv2d(conv9, gen_c, k_h=3, k_w=3, d_h=1, d_w=1, name='conv9_conv1')
        conv9 = batch_norm(conv9, name='conv9_batch1', _ops=_gen_train_ops)
        conv9 = tf.nn.relu(conv9, name='conv9_relu1')
        conv9 = conv2d(conv9, gen_c, k_h=3, k_w=3, d_h=1, d_w=1, name='conv9_conv2')
        conv9 = batch_norm(conv9, name='conv9_batch2', _ops=_gen_train_ops)
        conv9 = tf.nn.relu(conv9, name='conv9_relu2')

        # output layer: (N, 640, 640, 32) -> (N, 640, 640, 1)
        output = conv2d(conv9, 1, k_h=1, k_w=1, d_h=1, d_w=1, name='conv_output')
        
        return tf.nn.sigmoid(output)

def sample_imgs(x_data):
    return sess.run(g_samples, feed_dict={X: x_data})     

def batch_norm(x, name, _ops, is_train=True):
    """Batch normalization."""
    with tf.variable_scope(name):
        params_shape = [x.get_shape()[-1]]

        beta = tf.get_variable('beta', params_shape, tf.float32,
                               initializer=tf.constant_initializer(0.0, tf.float32))
        gamma = tf.get_variable('gamma', params_shape, tf.float32,
                                initializer=tf.constant_initializer(1.0, tf.float32))

        if is_train is True:
            mean, variance = tf.nn.moments(x, [0, 1, 2], name='moments')

            moving_mean = tf.get_variable('moving_mean', params_shape, tf.float32,
                                          initializer=tf.constant_initializer(0.0, tf.float32),
                                          trainable=False)
            moving_variance = tf.get_variable('moving_variance', params_shape, tf.float32,
                                              initializer=tf.constant_initializer(1.0, tf.float32),
                                              trainable=False)

            _ops.append(moving_averages.assign_moving_average(moving_mean, mean, 0.9))
            _ops.append(moving_averages.assign_moving_average(moving_variance, variance, 0.9))
        else:
            mean = tf.get_variable('moving_mean', params_shape, tf.float32,
                                   initializer=tf.constant_initializer(0.0, tf.float32), trainable=False)
            variance = tf.get_variable('moving_variance', params_shape, tf.float32, trainable=False)

        # epsilon used to be 1e-5. Maybe 0.001 solves NaN problem in deeper net.
        y = tf.nn.batch_normalization(x, mean, variance, beta, gamma, 1e-5)
        y.set_shape(x.get_shape())

        return y


def conv2d(input_, output_dim, k_h=5, k_w=5, d_h=2, d_w=2, stddev=0.02, name='conv2d'):
    with tf.variable_scope(name):
        w = tf.get_variable('w', [k_h, k_w, input_.get_shape()[-1], output_dim],
                            initializer=tf.truncated_normal_initializer(stddev=stddev))
        conv = tf.nn.conv2d(input_, w, strides=[1, d_h, d_w, 1], padding='SAME')

        biases = tf.get_variable('biases', [output_dim], initializer=tf.constant_initializer(0.0))
        # conv = tf.reshape(tf.nn.bias_add(conv, biases), conv.get_shape())
        conv = tf.nn.bias_add(conv, biases)

        return conv    
    
def upsampling2d(input_, size=(2, 2), name='upsampling2d'):
    with tf.name_scope(name):
        shape = input_.get_shape().as_list()
        return tf.image.resize_nearest_neighbor(input_, size=(size[0] * shape[1], size[1] * shape[2])) 

def max_pool_2x2(x, name='max_pool'):
    with tf.name_scope(name):
        return tf.nn.max_pool(x, ksize=[1, 2, 2, 1], strides=[1, 2, 2, 1], padding='SAME')    
        
def load_images_under_dir(path_dir):
    files = all_files_under(path_dir)
    return imagefiles2arrs(files)

def all_files_under(path, extension=None, append_path=True, sort=True):
    if append_path:
        if extension is None:
            filenames = [os.path.join(path, fname) for fname in os.listdir(path)]
        else:
            filenames = [os.path.join(path, fname)
                         for fname in os.listdir(path) if fname.endswith(extension)]
    else:
        if extension is None:
            filenames = [os.path.basename(fname) for fname in os.listdir(path)]
        else:
            filenames = [os.path.basename(fname)
                         for fname in os.listdir(path) if fname.endswith(extension)]

    if sort:
        filenames = sorted(filenames)

    return filenames

def imagefiles2arrs(filenames):
    """"
    ToDo:
    The PIL read the tiff image is so wired, needs to see what's going on inside
    Our tiff data used lzw compression, hard to read by PIL. Easier to use opencv
    """
    img_shape = image_shape(filenames[0])
    images_arr = None
    if len(img_shape) == 3:
        images_arr = np.zeros((len(filenames), img_shape[0], img_shape[1], img_shape[2]), dtype=np.float32)
    elif len(img_shape) == 2:
        images_arr = np.zeros((len(filenames), img_shape[0], img_shape[1]), dtype=np.float32)

    for file_index in range(len(filenames)):
#        img = Image.open(filenames[file_index])        
        img = cv2.imread(filenames[file_index], cv2.IMREAD_UNCHANGED)    
        #imgN = np.array(img)
        images_arr[file_index] = img

    return images_arr  

def image_shape(filename):
    #img = Image.open(filename)
    img = cv2.imread(filename, cv2.IMREAD_UNCHANGED)
    #img_arr = np.asarray(img)
    #img_shape = img_arr.shape
    img_shape = img.shape
    return img_shape    
    
def read_img_from_mat(filename):
    mat_contents = h5py.File(filename)
    data = mat_contents['tileStruct/data']
    name = mat_contents['tileStruct/name']
    imagearray = np.zeros((data.shape[0], mat_contents[data[0][0]].value.shape[0], \
                    mat_contents[data[0][0]].value.shape[1], mat_contents[data[0][0]].value.shape[2]), \
                    dtype=np.float32)
    for i in range(data.shape[0]):
        imagearray[i] = mat_contents[data[i][0]].value    
    return imagearray
    
def add_prediction_backTo_mat(filename, maskarray):
    print(maskarray.shape)
    hdf5 = h5py.File(filename, 'a')
    hdf5.create_dataset('tileStruct/mask', data = maskarray)
    hdf5.close()

    