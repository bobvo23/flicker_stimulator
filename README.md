# flicker_stimulator
SSVEP Stimulator using MATLAB and Psychtoolbox

This is a 4 classes (or more) flickering stimulator for Steady State Evoked Potential experiment. The software generate four different target as can be seen in this video.
[Youtube demo video](https://www.youtube.com/watch?v=HriCj1_7jdI)
This tool presents a stable flickering frequencies which are usable for BCI applications.

**Key parameters** 
+ Current supported target: 4 different frequencies
+ Supported frequencies: [6.66, 7.5, 8.75, 10, 12, 15, 20] Hz

**Prerequisites:**
+ 64-Bit Matlab version 7.14 (R2012a) or later
+ Psychtoolbox 3: http://psychtoolbox.org/
+ System Requirements: any Nvidia or AMD graphic card, built-in Intel graphic cards do not work properbly (more at Psychtoolbox website)

**How to use**
+ Install Psychtoolbox 3
+ Download this repository to your computer 
+ Add lcms.m and square_flicker.m to MATLab searching directory
+ Run square_flicker function. A window with 4 flickering frequency should be appeared on your desktop.

**Discussion**
 + The methodology of this software
 https://beta.groups.yahoo.com/neo/groups/PSYCHTOOLBOX/conversations/topics/20675

**Credits**
 + Josh, LCMS Matlab function (Least Common Multiple Set): https://www.mathworks.com/matlabcentral/fileexchange/24670-least-common-multiple-set
 + Hubert Cecotti, Ivan Volosyak, Axel Graser. Reliable visual stimuli on LCD screens for SSVEP
based BCI. The 2010 European Signal Processing Conference (EUSIPCO-2010), Aug 2010, Aalborg, Denmark. 
 + Psychtoolbox 3. 
 
**LICENSE - "MIT License"**
 
 Author: Bob and you.

 
