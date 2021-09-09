Description: In this work, an extended version of Non-negative Matrix Partial Co-Factorization (NMPCF) is proposed to suppress RS while preserving the wheezing acoustic content. Here, we assume that RS can be considered as repetitive sound events during breathing so, RS can be modeled by sharing together the spectral patterns found in each respiratory stage (segment), inspiration or expiration, with a respiratory training signal. However, this sharing of patterns can not be applied to wheezes since WS could not be present at each segment due to their unpredictable nature in time motivated by the pulmonary disorder. To improve the sound separation performance of the conventional NMPCF that treats equally all segments of the spectrogram, the main contribution of the proposed method adds higher importance to those segments classified as non-wheezing using inter-segment information informed by a wheezing detection system. As a result, our proposal is able to characterize RS more accurately by forcing to model more on those non-wheezing segments in the bases sharing process into the NMPCF decomposition. Specifically , IIS-NMPCF consists of three stages: i) Segmentation (first stage); ii) Classification between presence/absence of WS (second stage) and finally iii) Adding weighting into the NMPCF decomposition (third stage).

Input signals:
- Input mixture signal: single-channel signal composed of both RS and WS.
- Respiratory training signal: single-channel signal composed of concatenation of different respiratory stages of RS (WS are not active).

Output signals:
- Estimated WS signal: this signal is composed of the WS obtained from the separation algorithm.
- Estimated RS signal: this signal is composed of the RS extracted in the separation algorithm.

Files:
- The main file to be run has been denoted as "Main_IIS_NMPCF.m". 
- The function denoted as "amie_seg.m" implements the respiratory segmentation stage defined in reference [53] of the manuscript. This function corresponds to the first stage of the proposed method.
- The function denoted as "class_segment.m" implements a wheezing detection algorithm previously developed by authors in reference [54] of the manuscript. This function corresponds to the second stage of the proposed method.
- The function denoted as "nmpcf_weight.m" adding weighting into the NMPCF decomposition. This function corresponds to the third stage of the proposed method.
- The functions denoted as "stageI.m, stageII.m and stageIII.m" define the stages into which the "class_segment.m" algorithm is divided. 
- The function denoted as "sg.m" computes the spectrogram of a signal. 
- The function denoted as "invspecgram.m" applies the inverse overlap-add STFT to synthesize a signal in the time domain. 

Note that the term RS refers to normal respiratory sounds (WS are not active) and the term WS refers to wheezing sounds (RS are not active).


