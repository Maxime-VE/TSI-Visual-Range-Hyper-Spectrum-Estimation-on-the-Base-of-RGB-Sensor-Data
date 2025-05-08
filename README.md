# Visual Range Hyper Spectrum Estimation on the Base of RGB Sensor Data
---
This project aims to define an innovative methodology to Hyperspectral imaging conversion. This research project was supervised by _Dr.sc.ing., Professor Alexander Grakovski_ in the context of Student Project class in TSI, Riga for academic exchange.

![Logo](https://tsi.lv/wp-content/uploads/2024/01/tsi_logo_en_blue.svg)

---

## 🗂️ Repository Organazation
This directory is divided into three main folders:

1. The first `1.Simulation RGB-CMY dataset` folder contains the code structure necessary to run the following MATLAB scripts:
    - `color_curves_visualisation.m`: Displays the curves from the CSV file `SensCurves_WRGBCMY.txt`, which represent the intensity curves of each color as a function of wavelength (ranging from 300 to 900 nm across 3000 samples).

    - ` RGB_CMY_simulation.m`: Contains MATLAB code for visualizing different preprocessing steps applied to the input hyperspectral image. 
    ⚠️ Note: This script includes a variable `demo_mode`.
    If set to true, it processes a single pixel and displays the steps through plots.
    If set to false, it applies the processing to all pixels and generates a CSV output file containing the computed responses for R, G, B, C, M, and Y channels.

    - `HyperspectralApp.mlapp`: A MATLAB app for visualizing the hyperspectral image (hypercube). 
    This file requires to install some libraries :
        - `Image Processing Toolbox`
        - `Hyperspectral Image Processing`
    Installation process of add-on tutorial is available at : [Link here https://www.mathworks.com/help/matlab/matlab_env/get-add-ons.html](https://www.mathworks.com/help/matlab/matlab_env/get-add-ons.html)
    
2. The second `2.Neural Network` contains code structure necessary to run the neural network code in MATLAB

3. The third `files` contains all resources related to the code, including input and output files, supplementary materials like screenshot, and other supporting data.

---

## 🔧 How to get the content of this project on your machine

This guide shows you how to easily download this project from GitHub.


#### Prerequisites

- A web browser (Chrome, Firefox, etc.)
- Internet access

#### Method 1: Download as a ZIP File

1. Go to the **Home page of the project**.
2. Click the green **"Code"** button.
3. In the dropdown menu, click **"Download ZIP"**.
4. The ZIP file will be downloaded to your computer.
5. **Unzip** the file to access the project contents.


#### Method 2 (Optional): Clone the Repository with Git

If you have Git installed on your machine (through command line terminal or a GitBash terminal) , you can clone the repository using:

```bash
git clone https://github.com/Maxime-VE/TSI-Visual-Range-Hyper-Spectrum-Estimation-on-the-Base-of-RGB-Sensor-Data
```
This command will download unzipped version of the repository at the current path you run the command

---
## 🧾 Abstract
VISUAL RANGE HYPER SPECTRUM ESTIMATION ON THE BASE OF RGB
SENSOR DATA

Kettou Sofiane, Lemoine Philippe, Roger Nathan, Vettorato Maxime
Transport and Telecommunication Institute
Lauvas 2, Riga, LV-1019, Latvia
sofianekettoutravail@gmail.com,
philzemonk@gmail.com,
nathanroger.36076@gmail.com,
vettoratomaxime@gmail.com

Keywords: `Hyperspectral imaging`, `RGB sensor simulation`, `Spectral data reconstruction`, `Color space conversion`, `Artificial neural network`

Computer vision systems make it possible to capture real-world data through electronic equipment
for processing. These systems are increasingly used in fields such as navigation, the medical sector, and
security. One particular aspect, the image processing, is at the core of certain processes. It enables the
capture of specific wavelength bands. Specialized sensors, known as multispectral and hyperspectral,
which are complex and very expensive, can capture Infrared + RGB bands or Infrared + RGB +
Ultraviolet bands with wavelengths ranging between approximately 380-780nm (visible), 780-2500nm
(infrared), and 100-400nm (ultraviolet). A less costly alternative would be to reconstruct a hyperspectral
image from the output of an RGB sensor. To achieve this, a method is considered that would artificially
and iteratively increase the number of channels in an image starting from an RGB-only input to
progressively get the full hyperspectral image. This study aims to develop a tool capable of performing
this task on a smaller scale by first simulating the RGB and hypothetical RGB-CMY sensor outputs from
hyperspectral images and then establishing a relationship between RGB and CMY sensor data.
The methodology adopted is divided into four parts. First, natural hyperspectral datasets are
collected to form the initial data source. From these datasets, the RGB and CMY sensor output are
simulated by applying spectral sensitivity curves following the method proposed by (Vora et al., 2001),
which presents a realistic simulation of sensor output using spectral filtering. Then, the simulated output
of this process is cleaned and normalized to obtain a synthetic RGB-CMY dataset suitable for the machine
learning tasks.

In the following part of our study, an Artificial Neural Network (ANN) will be designed to predict
CMY channels output data from a RGB channels input data. This methodology relies on the paper of
(Dolz et al., 2022), which highlights the efficiency of neural networks to estimate spectral bands not
present in dataset. (Ahmed et al., 2025) validate this methodology by adding that Convolutional Neural
Networks (CNNs) perform relevant results to establish relationships between non-linear spectral bands.
As a conclusion of this study the neural network's performance will be evaluated using standard
metrics (e.g. MSE, MAE and R²). As presented in the paper of (Cheick Tidiani et al., 2022), where this
process allows to demonstrate the effectiveness of deep learning techniques especially for spectral data
reconstruction.

*Acknowledgements*
The research is supervised by Dr.sc.ing., Professor Alexander Grakovski.

*References*
1. Ahmed, M. T., Monjur, O., Alin, K., & Kamruzzaman, M. (2025). A comprehensive review of deep
learning-based hyperspectral image reconstruction for agri-food quality appraisal. Articial Intelligence
Review, 58(4). Available at: https://doi.org/10.1007/s10462-024-11090-w
2. Cheick Tidiani, C., Alboody, A., Puigt, M., & Roussel, G. (2022). Complétion par apprentissage profond
de séries temporelles d'images multi-spectrales à partir d'images hyper-spectrales. In: Proceedings of
Colloque GRETSI, Nancy, France, September 2022. [⟨hal-03684726⟩](https://hal.science/hal-03684726)
3. Dolz, M. M., Siegmann, B., Pérez-Suay, A., & García-Soria, J. L. (2022). Neural Network
Emulation of Synthetic Hyperspectral Sentinel-2-Like Imagery With Uncertainty. IEEE. Journal of
Selected Topics in Applied Earth Observations and Remote Sensing, PP(99), 1-11. Available at:
https://doi.org/10.1109/JSTARS.2022.3231380
4. Vora, P., Farrell, J. E., Tietz, J. D., & Brainard, D. H. (2001). Image capture: Simulation of sensor
responses from hyperspectral images. IEEE Transactions on Image Processing, 10(2), 307-316.
Available at: https://doi.org/10.1109/83.902295

---

## 🔗 Authors

- [Maxime VETTORATO - @Maxime-VE](https://github.com/Maxime-VE)
- [Nathan ROGER - @H1drAHub](https://github.com/H1drAHub)
- [Philippe LEMOINE - @PhilZeMonk](https://github.com/PhilZeMonk)
- [Sofiane KETTOU - @SofianeKETTOU](https://github.com/SofianeKETTOU)

