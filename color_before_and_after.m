%-----runing every color BEFORE flipping colors-----
cfg.stepcolor = [0 128 255 0 255 128;10 20 30 40 50 60];


colors = unique(cfg.stepcolor(1,:)); % list with colors
counter = [1:length(colors)];        %creating numbers to name the trigger
for i = 1:length(counter)
    trigName(i) = 100 + counter(i);
end
constant = [colors ; trigName] %matrix with colornames and triggernames as tuple
for color = constant
                Screen('FillRect', win , color(1) ,cfg.fillRect' ); %black
                triggerNum = color(2);
                
                WaitSecs(5);
                Screen('Flip', win);
                
                if USE_EYETRACKING
                    Eyelink('command', '!*write_ioport 0x378 %d',triggerNum);
                    WaitSecs(0.01);    Eyelink('command', '!*write_ioport 0x378 %d',0);WaitSecs(0.01);
                else
                    lptwrite(1,triggerNum)
                end
end


%-----runing every color AFTER flipping colors-----



colors_after = unique(cfg.stepcolor(1,:)); % list with colors
counter_after = [1:length(colors_after)];        %creating numbers to name the trigger
for i = 1:length(counter_after)
    trigName_after(i) = 200 + counter_after(i);
end
constant_after = [colors_after ; trigName_after] %matrix with colornames and triggernames as tuple
for color = constant
                Screen('FillRect', win , color(1) ,cfg.fillRect' ); %black
                triggerNum = color(2);
                
                WaitSecs(5);
                Screen('Flip', win);
                
                if USE_EYETRACKING
                    Eyelink('command', '!*write_ioport 0x378 %d',triggerNum);
                    WaitSecs(0.01);    Eyelink('command', '!*write_ioport 0x378 %d',0);WaitSecs(0.01);
                else
                    lptwrite(1,triggerNum)
                end
end
