# Preterm Neonates Breathing Sounds Analysis 

## Abstract 
Combining signal processing and biomedical, the project focuses on the breathing sound analysis of premature newborns with respiratory deficiency. In connection with a medical team, the work consisted first in signal preprocessing to remove crying by relying on labeled signals. Then, the extraction of signal features was necessary to learn more about Surfactant Replacement Therapy. 

## Vocabulary
**CS:** Crying segments 

**NCS:** Non-crying segments

**RDS:** Respiratory Distress Syndrome

**SRT:** Surfactant Replacement Therapy

## File Organization

The algorithm is divided into several parts: 
 - Initialisation of data and creation of Excel files. 
 - Crying removal: First phase of learning to detect them (labelling + finding useful features to differentiate CSs from NCs + threshold determination). Second phase in removing CSs.
 - Features extraction.
 - Write the features on the Excel file.

 ### DATA

#### Labels_New 
Audacity text files corresponding of the CS/NCS annotations of three observators. There are named like this: ```ObservatorID_SampleID```. It is composed of 35 files corresponding to 35 recordings.

#### Database
The entire set of recordings for this project. There are 106.

#### Learning_Database_New
35 samples of preterm neonates with RDS. The recordings have been done on babies who need SRT, before and after taking surfactant, and on some others who did not required SRT. Samples were recorded on babies who need SRT at three distinct times;
within an hour prior to SRT, within an hour following SRT and between 24 to 48 hours of life.

#### Filtered Signals
Obtained signals after crying removal and Butterworth filtering between [100-1200] Hz.


### CODES 
``` main_Julie.m``` : Main file of the project. Deals with functions to do the preprocessing and fetaures extraction, and creates and Excel file containing the different features.

``` read_samples.m``` : Read the samples of a folder and return them all in a matrix. Each line corresponds to a sample.

#### Preprocessing
##### Crying removing 
``` crying_learning.m``` : Main file for learning the features of CS and NCS.

``` labelling.m``` : Labels the recordings using Audacity text files (thank to a moving average) and give the Fleiss'es KAPPA coefficients.

``` Fleiss.m``` : Compute the Fleiss'es kappa.

``` CS_NCS_pure_window.m``` : Search pure window of CS and NCS, and return them.

``` label2section.m```: With the placement of the CS/NCS in the label_final matrix returned by labelling.m, this function gives the corresponding piece of signal.

``` label2signal.m```: This function gives the corresponding piece of signal(time/amplitude) corresponding to a certain position in the matrix final_label.

``` power_ratio_band.m```: Calculate the power ratio of NCS/CS (depending on flag_section) of a signal. 

```powerband_segment.m```: Take a signal and return the powerband of all sections. 

``` spectrogram_CS.m```: Display the spectrogram and the time representation with CS and NCS of a part of a signal AND return its spectrogram. 

``` NCS_CS_features_boxplot.m```: Extract some features of CS and NCS, return them and do their boxplots.

```powerband_segment.m```: Take a signal and return the powerband of all segments.

```threshold_ROC.m```: Based on powerband. Compute the ROC to find the good threshold which will distinguish the CSs from NCSs.

``` crying_removing.m```: Remove the CS in all the signals.

##### Filtering 
```filterbp.m ```: Filter signals using the ButterWorth Filter. 


#### Features 
```temporal_features.m```: Computes the Zero Crossing Rate.

```spectral_features.m```: Main file of feature extraction. Computes the following spectral features: meanPSD; stdPSD; medPSD; bw; p25; p75; IQR; TP; p100_200; p200_400; p400_600; p600_800; p800_1000; p1000_1200; spectrum_slope2; r_square2; nb_pks_MAF;  f_higherPk_MAF; dif_higherPks_MAF; nb_pks_GMM;  f_higherPk_GMM; dif_higherPks_GMM; GMM_parameters; pxx.

```Welch_periodogram.m```: Computes the Welch Periodogram.

```peak_features.m```: Computes peak features: higher peak; number of peaks; their frequencies.

```mfcc_coeffs.m ```: Computes the mean of the fisrt 6 MFCCs coefficients of a signal. The MFCCs corresponding to discounitnuities   were removed. 

```lpc_lsf_coeff.m```: Gives the first 6 coefficients of LPC and LSF.


#### Display
```display_NCS_CS_annotations.m```: Displays the annotated labels CS and NCS of a signal. 

```display_CS_NCS_final.m```: Display the rough signal, the one with the actual labels, the one with the predicted labels and finally the signal without CS.

```display_PR_NCS_CS_interquartiles.m```: Displays the periodograms of annotated NCS and CS. 

```display_power_spectrum ```: Display power spectrum with its deviation (fisrt and third quartiles).


