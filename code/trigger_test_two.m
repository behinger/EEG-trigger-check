%% Open Screen
% %
USE_EYETRACKING = 0;
USE_TRIGGER = 0;



if ~USE_EYETRACKING
    if USE_TRIGGER          %changed like this by bene
        addpath('matlabtrigger')

        ppdev_mex('CloseAll')
        ppdev_mex('Open',1)
    end
end
whichScreen = max(Screen('Screens'));

sca

[win,winRect] = Screen('OpenWindow',0,0,[0,0,200,200]);

scr_w = winRect(3);
scr_h = winRect(4);
cfg = [];
cfg.method = 'stepwise';
cfg.background = 0;
cfg.fillRect = []; %the whole screen is used
% cfg.fillRect = [51 51 52 52;scr_w-51 scr_h-51 scr_w-50 scr_h-50]; %one pixel left top one pixel right bottom
%cfg.fillRect = [scr_w-50,scr_h-50, scr_w,scr_h]; %only a small part for the diode is used
cfg.stepcolor = [0 128 255 0 255 128;10 20 30 40 50 60]; % default , colors with übergängen nad triggernames
% cfg.stepcolor = [13 242;5,95]; % default
% cfg.stepcolor = [0 255 50 255 100 255 150 255 200 255 225 255;1 10 50 11 100 12 150 13 200 14 225 15]; % intoTheWild Conditions

Screen('FillRect', win, cfg.background);                                     % Make it
Screen('Flip', win);                                                            % Render it in the monitor
[monitorFlipInterval nrValidSamples stddev ] =Screen('GetFlipInterval', win);   % Get the refresh rate of the monitor

% % Initialize the keyboard
KbName('UnifyKeyNames');
KbCheck;

%% -----EYETRACKING-----
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
%-----runing every color BEFORE flipping colors-----
cfg.stepcolor = [0 128 255 0 255 128;10 20 30 40 50 60];


colors = unique(cfg.stepcolor(1,:)); % list with colors
counter = [1:length(colors)];        %creating numbers to name the trigger
for i = 1:length(counter)
    trigName_before(i) = 100 + counter(i);  %names of trigger 101, 102, 103...
end
constant = [colors ; trigName_before] %matrix with colornames and triggernames as tuple
for color = constant
                Screen('FillRect', win , color(1) ,cfg.fillRect' ); 
                
                triggerNum = color(2); %hier triggername bzw trigName noch anpassen ändern!!!!!!!
                Screen('Flip', win);
                
                if USE_EYETRACKING
                    Eyelink('command', '!*write_ioport 0x378 %d',triggerNum);
                    WaitSecs(0.01);    Eyelink('command', '!*write_ioport 0x378 %d',0);WaitSecs(0.01);
                elseif USE_TRIGGER
                    lptwrite(1,triggerNum)
                end
                WaitSecs(5);
end



%% -----Flipping!!!-----
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
            elseif USE_TRIGGER
                lptwrite(1,10)
            end
            
            
        end
    case 'stepwise'
        for k = 1:20
            %Show Straight
            %     Screen('SelectStereoDrawBuffer', win, 1);
            
            for color = cfg.stepcolor
                Screen('FillRect', win , color(1) ,cfg.fillRect' ); %black
                triggerNum = color(2);
                
                WaitSecs(0.15 + rand *0.025);
                Screen('Flip', win);
                
                if USE_EYETRACKING
                    Eyelink('command', '!*write_ioport 0x378 %d',triggerNum);
                    WaitSecs(0.01);    Eyelink('command', '!*write_ioport 0x378 %d',0);WaitSecs(0.01);
                elseif USE_TRIGGER
                    lptwrite(1,triggerNum)
                end
            end
            
            
        end
        
end


%% -----runing every color AFTER flipping colors-----



colors_after = unique(cfg.stepcolor(1,:)); % list with colors
counter_after = [1:length(colors_after)];        %creating numbers to name the trigger
for i = 1:length(counter_after)
    trigName_after(i) = 200 + counter_after(i); % names of trigger 201, 202, 203...
end
constant_after = [colors_after ; trigName_after] %matrix with colornames and triggernames as tuple
for color = constant_after
                Screen('FillRect', win , color(1) ,cfg.fillRect' ); %black
                trigName_after = color(2);
                
                Screen('Flip', win);
                
                if USE_EYETRACKING
                    Eyelink('command', '!*write_ioport 0x378 %d',trigName_after);
                    WaitSecs(0.01);    Eyelink('command', '!*write_ioport 0x378 %d',0);WaitSecs(0.01);
                else
                    lptwrite(1,trigName_after)
                end
                WaitSecs(5);

end

%% -----fast as possible flipping-----
cfg.fastcolor = [0 255; 66 67]

for k = 1:200
    for color_fast = cfg.fastcolor
        Screen('FillRect', win , color_fast(1) ,cfg.fillRect' ); %black
        trigName_fast = color_fast(2);
        
        Screen('Flip', win);
        
        if USE_EYETRACKING
            Eyelink('command', '!*write_ioport 0x378 %d',trigName_fast);
            WaitSecs(0.01);    Eyelink('command', '!*write_ioport 0x378 %d',0);WaitSecs(0.01);
        elseif USE_TRIGGER
            lptwrite(1,trigName_fast)
        end
    end
end
