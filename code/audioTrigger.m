[win,winRect] = Screen('OpenWindow',0,0,[100,100,200,200]);

if EyelinkInit()~= 1; %
    return;
end;

%initialize with defaults, tell the Eyetracking on what screen to draw
el=EyelinkInitDefaults(win);

fprintf('\n\nINITIALIZING EYETRACKER\n');
Screen('Flip', win);
% % open an eye-tracker file
Eyelink('OpenFile', 'trigTest');
%%
[y,Fs,NBITS]=wavread('beep.wav');
y = sin(linspace(0,1,Fs/4)*800);
for k = 1:255

sound(y,Fs,NBITS);

Eyelink('command', '!*write_ioport 0x378 %d',k);
    WaitSecs(0.01);    Eyelink('command', '!*write_ioport 0x378 %d',0);WaitSecs(0.01);
    WaitSecs(0.5)
end