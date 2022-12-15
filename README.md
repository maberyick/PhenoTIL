# PhenoTIL (v1)

<a name="readme-top"></a>

<!-- PROJECT SHIELDS -->
<!-- https://github.com/Ileriayo/markdown-badges -->
[![MATLAB 2022b](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com)
[![Python 2.7](https://img.shields.io/badge/python-2.7-blue.svg)](https://www.python.org/downloads/release/python-270/)
[![minimal R version](https://img.shields.io/badge/R%3E%3D-3.2.4-6666ff.svg)](https://cran.r-project.org/)

<!-- ABOUT THE PROJECT -->
## About The Project

PhenoTIL in general is the phenotypic features from Tumor-Infiltrating Lymphocytes (TIL) on H&E images. It is a multimodal pipline that ultimetly builds a immune-related biomarker that can be associated with overall survival of lung cancer patients.
It consists of different modalities from MATLAB, Python to R. Each offering an specific solution. This work is part of a upcoming paper.

Main aspects of PhenoTIL:
* Nuclei segmentation with lymphocyte identification and feature extraction of immune cell morphological aspects cell by cell.
* Feature analysis of immune cells with unsupervized clustering.
* High quality visualization of statistical analysis of the signature.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With

List of major frameworks/libraries used to build the project.

* [![Visual Studio Code](https://img.shields.io/badge/Visual%20Studio%20Code-0078d7.svg?style=for-the-badge&logo=visual-studio-code&logoColor=white)](https://code.visualstudio.com/)
* [![RStudio](https://img.shields.io/badge/RStudio-4285F4?style=for-the-badge&logo=rstudio&logoColor=white)](https://posit.co/downloads/)
* [![R](https://img.shields.io/badge/r-%23276DC3.svg?style=for-the-badge&logo=r&logoColor=white)](https://cran.r-project.org/)
* [![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)](https://www.python.org/)
* [![Spyder](https://img.shields.io/badge/Spyder-838485?style=for-the-badge&logo=spyder%20ide&logoColor=maroon)](https://www.spyder-ide.org/)
* [![NumPy](https://img.shields.io/badge/numpy-%23013243.svg?style=for-the-badge&logo=numpy&logoColor=white)](https://numpy.org/)
* [![Pandas](https://img.shields.io/badge/pandas-%23150458.svg?style=for-the-badge&logo=pandas&logoColor=white)](https://pandas.pydata.org/)
* [![Matplotlib](https://img.shields.io/badge/Matplotlib-%23ffffff.svg?style=for-the-badge&logo=Matplotlib&logoColor=black)](https://matplotlib.org/)
* [![scikit-learn](https://img.shields.io/badge/scikit--learn-%23F7931E.svg?style=for-the-badge&logo=scikit-learn&logoColor=white)](https://scikit-learn.org/stable/)
* [![SciPy](https://img.shields.io/badge/SciPy-%230C55A5.svg?style=for-the-badge&logo=scipy&logoColor=%white)](https://scipy.org/)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

PhenoTIL consists of three segments. 

1. The initial step is the preprocessing of whole-slide images (WSI), then tile generation using **MATLAB** and first nuclei segmentation #1 using deep learning (DL) **U-Net**.
2. The preprocessing of the H&E image with nuclei segmentation using machine learning (ML) and identification of lymphocyte cells. This also includes the feature extraction of the identified cells (done in **MATLAB**).
3. The unsupervised clusterization of the extracted features (done in **Python**).
4. The visualization of some statistical scripts implemented in the paper (done in **R**).

### HistoQC - (Python)
HistoQC is an open-source quality control tool for digital pathology slides, it can be run using Python. The project can be found here [HistoQC](https://github.com/choosehappy/HistoQC)
Once the WSI images are processed, different steps can be performed.

A sample WSI can be found in this link [wsi sample](https://drive.google.com/drive/folders/1jHjx6EadvRj2G-JvWLSuK8pQ5ieL2irT?usp=share_link)

### Prerequisites for running tile generation - (MATLAB)
To extract small tiles samples from WSI we perform `tile generation`. MATLAB dependencies are already provided in the `code/tilegen/` folder. Other dependencies are related to the toolbox offered with MATLAB.
Further dependency is the openslide libraries that are needed to process WSI images. They are provided in the folder but if issue are found (e.g. running on Linux), the library can be found with the below links. The script was run using MATLAB2022a (Academic Use).

1. [Openslide-matlab](https://github.com/fordanic/openslide-matlab)
2. [Openslide](https://openslide.org/download/)

### Running tile generation - (MATLAB)
The script `run_phenoTIL_WSI_tileGeneration` was done using the **Live Script** Option from MATLAB. It has few steps to perform tile generation and also create a binary mask from annotations done for isolating a tissue area (e.g. tumor area).

1. To run the tile generation, the lines of code can be found on the main script as:
    We add the dependencies
   ```matlab
   addpath(genpath('./code/tilegen/'))
   addpath(genpath('./code/tilegen/openslide-3.4.1'))
   addpath(genpath('./code/tilegen/libs_openslide'))
   addpath(genpath('./code/tilegen/openslide-matlab'))
   ```
    Then we simply run the script as `mainTileGenerationV2 input_path_image input_path_annotation output_path_tiles image_format`
   ```matlab
   mainTileGenerationV2 './data/test_set/wsi/' './data/test_set/wsi/' './output/matlab/tiles/' 'tiff'
   ```

### Prerequisites for running nuclei Segmentation #1 - (Python, Deep Learning)

The pre-trained model can be found in this link [model folder](https://drive.google.com/drive/folders/1jY0evRabZ6vW09qNTREGMxHF5N8Ez8s-?usp=share_link). It can be added to the folder `PhenoTIL_V1/model`.

1. As the codes are were written in Python 3.8 at the time, to reproduce the nuclei segmentation, we create a conda `environment`:
   ```sh
   conda create -n nucleipy python=3.8
   ```
   We then activate the environment
   ```sh
   activate nucleipy
   ```
2. We then install the old version of the opencv-python, Pillow and others:
   ```sh
   pip install -r requirements_nucleiSeg.txt
   pip install --upgrade pip
   pip install --upgrade tensorflow
   pip install opencv-python
   pip install Pillow
   ```
### Running nuclei segmentation #1 (Python)

1. We run the script, indicating the input as the folder containing the image (png format) and output the folder to save the mask. `python run_phenoTIL_python38_nucleiSegmentationDL.py input_path output_path`
   Activate the environment
      ```sh
   activate nucleipy
   ```
   Run the script
   ```sh
   python run_phenoTIL_python38_nucleiSegmentationDL.py '/data/test_set/' '/output/python/'
   ```
4. The results can be seen on the folder directory `phenoTIL_V1/output/python/` including the nuclei segmentation #1 `test_mask.png`

### Prerequisites for MATLAB

MATLAB dependencies are already provided in the `code` folder. Other dependencies are related to the toolbox offered with MATLAB.
The script was run using MATLAB2022a (Academic Use).

### Running nuclei segmentation #2 and feature extraction (MATLAB)

To run the script we follow the next steps:

1. We open MATLAB and locate the directory in the same as the phenoTIL main folder.
2. We run the script on MATLAB as shown below. It will run the script using the nuclei segmentation #1 mask:
    Script
   ```matlab
   run_phenoTIL_matlabr2020b_featureExtraction
   ```
   More specifically, the nuclei segmentation line is:
   ```matlab
   % input are (RGB image, color normalization (1=yes), lower value for the scales, upper value for the scales (2,4,8,10,12)) 
   nuclei = getWatershedMask(img,1,4,12);
   ```
   For the lymphocyte identification the line is:
   ```matlab
   % To get the lymphocytes from the nuclei mask and image we run it as
   % load the trained lymphocyte model
   lympModel = load('lymp_svm_matlab_wsi.mat');
   lympModel = lympModel.model;
   % Extract local (shape, size, intensity) features
   [nucleiCentroids,feat_simplenuclei] = get_localcellfeatures(img,nuclei);
   % Identify which is lymphocyte and which is not
   isLymphocyte = (predict(lympModel,feat_simplenuclei(:,1:7)))==1;
   % Identify the centroids of lymphocytes and non-lymphocytes
   lympCentroids=nucleiCentroids(isLymphocyte==1,:);
   nonLympCentroids=nucleiCentroids(isLymphocyte~=1,:);
   % Represent them as a binary mask
   rndLymp = round(lympCentroids);
   rndnonLymp = round(nonLympCentroids);
   bwLymp = bwselect(nuclei,rndLymp(:,1),rndLymp(:,2));
   bwnonLymp = bwselect(nuclei,rndnonLymp(:,1),rndnonLymp(:,2));
   % save the lymphocyte mask
   imwrite(bwLymp,'./output/matlab/test_lymp.png')
   imwrite(bwnonLymp,'./output/matlab/test_nonlymp.png')
   ```
   The line of code for the extraction of phenoTIL features is:
      ```matlab
   getAllFeatures_V2(input_path,output_path);
   ```
   It requires only the input path of the H&E images and the output path where the features are being saved.
3. (Optional) If the nuclei segmentation #1 mask is already saved. We can combine the nuclei segmentation #1 with nuclei segmentation #2. It offers more options to identify cells on a image sample.
   We run a set of line of codes (A script can be found at `/code/libs/fusion_masks.m`:
   ```matlab
   BW_ml = imread('./output/matlab/test_mask_ml.png'); % Load the mask from nuclei segmentation #1 (ML)
   BW = imread('./output/python/test_mask_dl.png'); % Load the mask from nuclei segmentation #2 (DL)
   BW = imbinarize(BW,'adaptive'); % Make it binary
   BW = bwareaopen(BW, 30); % Remove small objects detected
   BW = bwpropfilt(BW,'Area',[0 200]); % Remove bigger objects (e.g. grouped cells)
   BW_comb = BW + logical(BW_ml); % Combine both masks
   imwrite(BW_comb,'./output/python/test_mask_combined.png'); % Save the combined binary mask
   ```
4. The results can be seen on the folder directory `phenoTIL_V1/output/matlab/` including testing images. The `test.mat` file saved is the file with the morphometrical features for each of the identified lymphocyte cells. It will be used for clusterization on the Python script.

### Prerequisites for Python (Machine Learning)

1. As the codes were written in Python 2.7 at the time, to reproduce the feature extraction, we create a conda `environment`:
   ```sh
   conda create --name phenotil_py2 python=2.7
   ```
   We then activate the environment
   ```sh
   conda activate phenotil_py2
   ```
2. We then install the old version of the sklearn, numpy and others:

   ```sh
   pip install numpy==1.16.4
   pip install "scikit-learn==0.19.0"
   pip install pillow
   pip install pandas
   pip install matplotlib
   pip install sio
   pip install scipy
   pip install joblib
   pip install hdf5storage
   ```

### Running unsupervized clustering (Python)

1. To run the Python script we simply run the code once the conda environment is activated:

   ```sh
   python run_phenoTIL_python27_featureClustering.py
   ```

2. The cluster of the cells file is saved as `phenoTIL_V1/output/python/test_cls.mat`

### Prerequisites for R

For the depndencies make sure that the following libraries are installed with R.
1. For hrbrthemes, please follow installs from:  https://github.com/hrbrmstr/hrbrthemes

   ```R
   remotes::install_github("hrbrmstr/hrbrthemes")
   ```
2. The needed libraries are below:
`plyr
R.matlab
survcomp
Gmisc
skimr
Hmisc
boot 
table1
survival
survminer
gsubfn
ggplot2
ggnetwork
ggforce
waffle
ggpubr
uwot
gridExtra
grid
cowplot
lattice
ggsci
tidyverse
colourlovers
RColorBrewer
hexbin
viridis
patchwork
hrbrthemes
circlize
chorddiag
TCGAWorkflowData
DT
TCGAbiolinks
ggcorrplot
ComplexHeatmap
colorspace
GetoptLong
caret
pheatmap
EDASeq
GISTools`

3. Also for some libraries can be installed as:
   ```R
   devtools::install_github("mattflor/chorddiag")
   ```
   ```R
   install.packages("GISTools")
   ```

### Running visualizations (R)

For running the visualization scripts on R, run the script:

   ```R
   run_phenoTIL_R_FigurePlot.R
   ```
   
The resulting images will be plotted in the R environment. Some examples are saved at `/output/R/Rplots.pdf`

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->
## Usage

Some screenshots and image generated can be observe below.

<!-- _For more examples, please refer to the [Documentation](https://example.com)_ -->

### MATLAB output examples

The original H&E image sample and the figure plot for the identified cells (Green are the lymphocyte cells, Red the non-lymphocyte cells)

<p align="center">
  <img alt="Light" src="https://github.com/maberyick/PhenoTIL_V1/blob/main/data/test_set/test.png" width="45%">
&nbsp; &nbsp; &nbsp; &nbsp;
  <img alt="Dark" src="https://github.com/maberyick/PhenoTIL_V1/blob/main/output/matlab/identified_test.png" width="45%">
</p>


### R output examples

The example plots generated by R. (left) The plot of the clustered cells and (right) chord diagram plot of immune cell composition of the clusters.

<p align="center">
  <img alt="Light" src="https://github.com/maberyick/PhenoTIL_V1/blob/main/output/R/Rplots/Rplots-3.png" width="45%">
&nbsp; &nbsp; &nbsp; &nbsp;
  <img alt="Dark" src="https://github.com/maberyick/PhenoTIL_V1/blob/main/output/R/Rplots/Rplots-6.png" width="45%">
</p>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ROADMAP -->
## Roadmap

- [x] Update the README
- [x] Add back running scrips
- [ ] Add Additional Templates w/ Examples
- [ ] Add "components" document to easily copy & paste sections of the readme
- [ ] Multi-language Support
    - [ ] Spanish

Future uses will be added once are found or observed.

<!-- See the [open issues](https://github.com/othneildrew/Best-README-Template/issues) for a full list of proposed features (and known issues). -->

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->
## Contact

Cristian Barrera - cbarrera31@gatech.edu

Project Link: [https://github.com/maberyick/PhenoTIL_V1](https://github.com/maberyick/PhenoTIL_V1)

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/othneildrew/Best-README-Template.svg?style=for-the-badge
[contributors-url]: https://github.com/othneildrew/Best-README-Template/graphs/contributors