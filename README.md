# AcousticEchoCancelation
MATLAB implementation of an NLMS-based adaptive acoustic echo cancelation described by Saremi et al. 2023


License and disclaimer
The attached source code is provided under General Public License (GPL) version 3. Accordingly, the source code is provided ‘AS IT IS’ for general use. The creator(s) of the source code do NOT guarantee the feasibility or accuracy of the code for any application. The code can be modified and used for public and research purposes. This code cannot be used for industrial nor business-related purposes and it cannot be part of any privately-owned product unless otherwise agreed by the copy-right holder(s). 

Content
This Github repo provides the MATLAB implementation of an NLMS-based adaptive acoustic echo cancellation algorithm explained in Saremi et al. 2023. The repo also contains exemplary audio files that have been recorded in an FM928 medium duty Volvo truck in absence of engine noise (engine off) as well as in presence of engine noise (engine on). 

How to run the code?
‘Run_NLMS_AcousticEcoCancellation’ script runs the AEC algorithm by calling the ‘NLMS_AcousticEchoCanceller’ function which contains the actual adaptive process. This function relies on ‘DoubeTalk_detection’ which continuously estimates the cross-correlation between the reference signal (x[n]) and the captured microphone signal (d[n]) to detect double talks.  
When running ‘Run_NLMS_AcousticEcoCancellation’ script, please make sure that the corresponding audio files exist on the same folder.

