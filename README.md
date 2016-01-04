# EEG-trigger-check

## Requirements
  - EEGLAB (external)
  - ANTEEPIMPORT (1.10 for windows, we use a custom hacked 1.09 version for ubuntu)
  
## Datasets
 The datasets we provide here have been recorded at various stages of the luminance sensor.
 For example triggerCheckerLong has 500 repetitions of a sequence testing all pairs of transitions between 0, 128 and 255 with the first version of the ANTtriggerChecker.
 

## Example
For an example we run the triggerCheckerLong and plot the delay as here:
![White to Black Luminance Sensor output](/figures/triggerCheckerLong_white2black.png?raw=true "")
Notice that black values are positive and bright values negative.
