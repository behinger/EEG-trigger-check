%% Open Screen
% %
USE_EYETRACKING = 0;




if ~USE_EYETRACKING
    addpath('matlabtrigger')

    ppdev_mex('CloseAll')
    ppdev_mex('Open',1)
end
whichScreen = max(Screen('Screens'));

sca

[win,winRect] = Screen('OpenWindow',0,0);

scr_w = winRect(3);
scr_h = winRect(4);
cfg = [];
cfg.method = 'stepwise';
cfg.background = 0;
cfg.fillRect = []; %the whole screen is used
cfg.fillRect = [51 51 52 52;scr_w-51 scr_h-51 scr_w-50 scr_h-50]; %one pixel left top one pixel right bottom
%cfg.fillRect = [scr_w-50,scr_h-50, scr_w,scr_h]; %only a small part for the diode is used
%cfg.stepcolor = [0 128 255 0 255 128;10 20 30 40 50 60]; % default
cfg.stepcolor = [13 242;5,95]; % default
% cfg.stepcolor = [0 255 50 255 100 255 150 255 200 255 225 255;1 10 50 11 100 12 150 13 200 14 225 15]; % intoTheWild Conditions

Screen('FillRect', win, cfg.background);                                     % Make it
Screen('Flip', win);                                                            % Render it in the monitor
[monitorFlipInterval nrValidSamples stddev ] =Screen('GetFlipInterval', win);   % Get the refresh rate of the monitor

% % Initialize the keyboard
KbName('UnifyKeyNames');
KbCheck;

%%
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
% % open an eye-tracker file



%%
% 10 --> g2b
% 20 --> b2g
% 30 --> g2w
% 40 --> w2b
% 50 --> b2w
% 60 --> w2g
switch cfg.method
    case 'all'
        for k = 1:20:2000
            %Show Straight
            %     Screen('SelectStereoDrawBuffer', win, 1);
            
            Screen('FillRect', win , [1 1 1]*mod(k,128)*2 ,cfg.fillRect ); %black
            WaitSecs(rand(1)/10+0.1);
            Screen('Flip', win);
            
            if USE_EYETRACKING
                Eyelink('command', '!*write_ioport 0x378 %d',mod(k,128)+1);
                WaitSecs(0.01);    Eyelink('command', '!*write_ioport 0x378 %d',0);WaitSecs(0.01);
            else
                lptwrite(1,10)
            end
            
            
        end
    case 'stepwise'
        for k = 1:5000
            %Show Straight
            %     Screen('SelectStereoDrawBuffer', win, 1);
            
            for color = cfg.stepcolor
                Screen('FillRect', win , color(1) ,cfg.fillRect' ); %black
                triggerNum = color(2);
                
                WaitSecs(rand(1)/10+0.1);
                Screen('Flip', win);
                
                if USE_EYETRACKING
                    Eyelink('command', '!*write_ioport 0x378 %d',triggerNum);
                    WaitSecs(0.01);    Eyelink('command', '!*write_ioport 0x378 %d',0);WaitSecs(0.01);
                else
                    lptwrite(1,triggerNum)
                end
            end
            
            
        end
        
end