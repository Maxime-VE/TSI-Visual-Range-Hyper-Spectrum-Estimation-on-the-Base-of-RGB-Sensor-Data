This file README.txt come from webpage: http://xlim-sic.labo.univ-poitiers.fr/datasets/ICONES-HSI/index.php?lang=en

===============================================================
The ICONES Hyperspectral Satellite Imaging dataset (ICONES-HSI)
===============================================================

- Contains both HSI and RGB remote sensing images
- Number of Image Patches: 468
- Hyperspectral/RGB Image Patches size: 300x300 pixels
- Imaging Spectrometer: AVIRIS
- Number of Spectral Channels: Spectral radiance measurement data is sampled in 224 contiguous spectral channels (bands) between 365 and 2497 nanometers.



Images were generated from several HSI images from the NASA Jet Propulsion Laboratory's Airborne Visible InfraRed
Imaging Spectrometer (AVIRIS) https://aviris.jpl.nasa.gov/ "Courtesy NASA/JPL-Caltech."
The ICONES-HSI dataset includes also an RGB version of all patch images extracted from the AVIRIS RGB full image.

To ensure the correct annotation of the patches, an interactive interface has been developed. This interface
allows to select the patch to annotate. In parallel, with the use of the GPS coordinates included in the AVIRIS
metadata and the (x,y) position in the whole image, the interface extracts the local Google map. Thus, aerial
views with different angles and Google street views may help the user in annotating correctly each patch.
For all patches, we have added their corresponding RGB images obtained from the corresponding RGB images provided by (AVIRIS RGB Qlook)

We grouped the obtained HSI patches by visual inspection and Google maps content verification into 9 categories:

Table 1: Number of Images Annotated
	 -- ------------------------------
	| Category      | Number of images|
	| --------------------------------|
	| Agriculture   |   50            |
	| Cloud         |   29            |
	| Desert        |   54            |
	| Dense-Urban   |   73            |
	| Forest        |   69            |
	| Mountain      |   53            |
	| Ocean         |   68            |
	| Snow          |   55            |
	| Wetland       |   35            |
	 ---------------------------------



The data is organised into 9 folders. Each folder contains a set of AVIRIS patches that belong to the same category. For each patch we have:

1) HSI patch |--> *.hdr  (metadata of the HSI patch) |--> file type = ENVI Standard
                                                     |--> bands = 224
                                                     |--> wavelength
                                                     |--> ect.


             |--> *.img  (the HSI data)

2) The corresponding RGB image of the HSI patch |--> *.png



Please cite the following article if you use our dataset in your research:

"Olfa Ben-Ahmed, Thierry Urruty, Noël Richard and Christine Fernandez-Maloigne,
  "Toward Content-Based Hyperspectral Remote Sensing Image Retrieval (CB-HRSIR): A Preliminary Study Based on Spectral Sensitivity Functions",
  Remote Sensing Journal,Special Issue Image Retrieval in Remote Sensing, 2019, 11, 600."

https://www.mdpi.com/2072-4292/11/5/600