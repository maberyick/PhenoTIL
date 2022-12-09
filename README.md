# PhenoTIL (v1)

<a name="readme-top"></a>

<!-- PROJECT SHIELDS -->

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/maberyick/PhenoTIL_V1/main/main/README.md">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Best-README-Template</h3>

  <p align="center">
    An awesome README template to jumpstart your projects!
    <br />
    <a href="https://github.com/othneildrew/Best-README-Template"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/othneildrew/Best-README-Template">View Demo</a>
    ·
    <a href="https://github.com/othneildrew/Best-README-Template/issues">Report Bug</a>
    ·
    <a href="https://github.com/othneildrew/Best-README-Template/issues">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]](https://example.com)

Currently in development. Phenotypic features from Tumor-Infiltrating Lymphocytes (TIL) on H&amp;E images.

There are many great README templates available on GitHub; however, I didn't find one that really suited my needs so I created this enhanced one. I want to create a README template so amazing that it'll be the last one you ever need -- I think this is it.

Here's why:
* Your time should be focused on creating something amazing. A project that solves a problem and helps others
* You shouldn't be doing the same tasks over and over like creating a README from scratch
* You should implement DRY principles to the rest of your life :smile:

Of course, no one template will serve all projects since your needs may be different. So I'll be adding more in the near future. You may also suggest changes by forking this repo and creating a pull request or opening an issue. Thanks to all the people have contributed to expanding this template!

Use the `BLANK_README.md` to get started.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



### Built With

This section should list any major frameworks/libraries used to bootstrap your project. Leave any add-ons/plugins for the acknowledgements section. Here are a few examples.

* [![Next][Next.js]][Next-url]
* [![React][React.js]][React-url]
* [![Vue][Vue.js]][Vue-url]
* [![Angular][Angular.io]][Angular-url]
* [![Svelte][Svelte.dev]][Svelte-url]
* [![Laravel][Laravel.com]][Laravel-url]
* [![Bootstrap][Bootstrap.com]][Bootstrap-url]
* [![JQuery][JQuery.com]][JQuery-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

PhenoTIL consists of three segments. 

1. The preprocessing of the H&E image with nuclei segmentation and identification of lymphocyte cells. This also includes the feature extraction of the identified cells (done in **MATLAB**).
2. The unsupervised clusterization of the extracted features (done in **Python**).
3. The visualization of some statistical scripts implemented in the paper (done in **R**).

### Prerequisites for MATLAB

MATLAB dependencies are already provided in the `code` folder. Other dependencies are related to the toolbox offered with MATLAB.
The script was run using MATLAB2022a (Academic Use).

### Running feature extraction (MATLAB)

To run the script we follow the next steps:

1. We open MATLAB and locate the directory in the same as the phenoTIL main folder.
2. We run the script on MATLAB as: 
   ```matlab
   run_phenoTIL_matlabr2020b_featureExtraction
   ```

3. The results can be seen on the folder directory `phenoTIL_V1/output/matlab/` including testing images. The `test.mat` file saved is the file with the morphometrical features for each of the identified lymphocyte cells. It will be used for clusterization on the Python script.

### Prerequisites for Python

1. As the codes are were written in Python 2.7 at the time, to reproduce the feature extraction, we create a coda `environment`:

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

3. Also for some libraries, they can be installed as:
   ```R
   devtools::install_github("mattflor/chorddiag")
   ```
   ```R
   install.packages("GISTools")
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
  <img alt="Light" src="https://github.com/maberyick/PhenoTIL_V1/blob/main/data/test_set/test.png" width="30%">
&nbsp; &nbsp; &nbsp; &nbsp;
  <img alt="Dark" src="https://github.com/maberyick/PhenoTIL_V1/blob/main/output/matlab/identified_test.png" width="30%">
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

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Your Name - [@your_twitter](https://twitter.com/your_username) - email@example.com

Project Link: [https://github.com/your_username/repo_name](https://github.com/your_username/repo_name)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

Use this space to list resources you find helpful and would like to give credit to. I've included a few of my favorites to kick things off!

* [Choose an Open Source License](https://choosealicense.com)
* [GitHub Emoji Cheat Sheet](https://www.webpagefx.com/tools/emoji-cheat-sheet)
* [Malven's Flexbox Cheatsheet](https://flexbox.malven.co/)
* [Malven's Grid Cheatsheet](https://grid.malven.co/)
* [Img Shields](https://shields.io)
* [GitHub Pages](https://pages.github.com)
* [Font Awesome](https://fontawesome.com)
* [React Icons](https://react-icons.github.io/react-icons/search)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/othneildrew/Best-README-Template.svg?style=for-the-badge
[contributors-url]: https://github.com/othneildrew/Best-README-Template/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/othneildrew/Best-README-Template.svg?style=for-the-badge
[forks-url]: https://github.com/othneildrew/Best-README-Template/network/members
[stars-shield]: https://img.shields.io/github/stars/othneildrew/Best-README-Template.svg?style=for-the-badge
[stars-url]: https://github.com/othneildrew/Best-README-Template/stargazers
[issues-shield]: https://img.shields.io/github/issues/othneildrew/Best-README-Template.svg?style=for-the-badge
[issues-url]: https://github.com/othneildrew/Best-README-Template/issues
[license-shield]: https://img.shields.io/github/license/othneildrew/Best-README-Template.svg?style=for-the-badge
[license-url]: https://github.com/othneildrew/Best-README-Template/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/othneildrew
[product-screenshot]: images/screenshot.png
[Next.js]: https://img.shields.io/badge/next.js-000000?style=for-the-badge&logo=nextdotjs&logoColor=white
[Next-url]: https://nextjs.org/
[React.js]: https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-url]: https://reactjs.org/
[Vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D
[Vue-url]: https://vuejs.org/
[Angular.io]: https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white
[Angular-url]: https://angular.io/
[Svelte.dev]: https://img.shields.io/badge/Svelte-4A4A55?style=for-the-badge&logo=svelte&logoColor=FF3E00
[Svelte-url]: https://svelte.dev/
[Laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white
[Laravel-url]: https://laravel.com
[Bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com
[JQuery.com]: https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white
[JQuery-url]: https://jquery.com 
