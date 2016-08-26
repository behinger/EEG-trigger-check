
USE_EYETRACKING = 1;
USE_TRIGGER = 0;



if ~USE_EYETRACKING
    if USE_TRIGGER          %changed like this by bene
        

        ppdev_mex('CloseAll')
        ppdev_mex('Open',1)
    end
end
whichScreen = max(Screen('Screens'));

sca
[win,winRect] = Screen('OpenWindow',1,[]);
 
scr_w = winRect(3);
scr_h = winRect(4);

if USE_EYETRACKING && EyelinkInit()~= 1; %
    return;
end;

%initialize with defaults, tell the Eyetracking on what screen to draw
if USE_EYETRACKING
    el=EyelinkInitDefaults(win);
    
    fprintf('\n\nINITIALIZING EYETRACKER\n');
    Eyelink('OpenFile', 'trigTest');
end
Screen('Flip', win);

cfg = [];
cfg.fastcolor = [0 255; 66 67];
cfg.fillRect = []; %the whole screen is used

for k = 1:3000
    for color_fast = cfg.fastcolor
        Screen('FillRect', win , color_fast(1) ,cfg.fillRect' ); %black
        trigName_fast = color_fast(2);
        
        Screen('Flip', win);
        fprintf('Trial %i / 3000 \n',k)
        if USE_EYETRACKING
            Eyelink('command', '!*write_ioport 0x378 %d',trigName_fast);
            WaitSecs(0.01);    Eyelink('command', '!*write_ioport 0x378 %d',0);WaitSecs(0.01);
        elseif USE_TRIGGER
            lptwrite(1,trigName_fast)
            WaitSecs(0.01);
        end
        WaitSecs(0.075+rand(1)/20);
    end
end
