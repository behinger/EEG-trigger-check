InitializePsychSound 
addpath('~/experiments/trigger_check/matlabtrigger/')
wavfilename= '/home/experiment/Downloads/impulsesound_test.wav'
   [y, freq] = audioread(wavfilename);
    wavedata = y';
    devices = PsychPortAudio('GetDevices') %<-- find the right one first
    nrchannels = size(wavedata,1); % Number of rows == number of channels.
    PsychPortAudio('Close')
        pahandle = PsychPortAudio('Open',2, [], 0, freq, nrchannels);
PsychPortAudio('FillBuffer', pahandle, wavedata);
try 
    ppdev_mex('Open',1)
catch
end
% Start audio playback for 'repetitions' repetitions of the sound data,
% start it immediately (0) and wait for the playback to start, return onset
% timestamp.
for k = 1:1000
t1 = PsychPortAudio('Start', pahandle, 1, 1, 1);
lptwrite(1,128)
WaitSecs(0.3);
PsychPortAudio('Stop', pahandle);
end
