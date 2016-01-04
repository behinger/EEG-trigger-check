# EEG-trigger-check

## Requirements
  - EEGLAB (external)
  - ANTEEPIMPORT (1.10 for windows, we use a custom hacked 1.09 version for ubuntu)
  
## Datasets
The datasets we provide here have been recorded at various stages of the luminance sensor.
We usually use a sequence of all pairs of transitions between rectangular ptaches of 0, 128 and 255 using PTB

Monitor was a BenQ XL2420t
#### Stage 1
Here we did not use a resitor, noise was very high. Black is positive, white is negative
 - whiteBasis2: Only white stimulus Monitor for 600s, fs 2048Hz
 - whiteBasis2: Only white stimulus LED for 372s, fs 2048Hz
 - 20150925_1608: 195 trials of the sequence
 - triggerCheckerLong: 500 trials of the sequence
 
### Stage 2
Here we added a small resistor, greatly enhancing our signal to noise. Black is negative, white is positive.
 - luminancev2_2: 435 trials of the sequence, 
 - grayvalues: this dataset consinsts of staircases iteratively enhancing the brightness in steps of 1, e.g. 0 to 1, 1 to 2, etc.


 

## Example
For an example we run the triggerCheckerLong and plot the delay as here:
![White to Black Luminance Sensor output](/figures/luminancev2_2.cnt_white2black.png?raw=true "")
