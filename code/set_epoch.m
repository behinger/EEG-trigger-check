function [raise_time_list1, reaction_time_list1,raise_time_list2, reaction_time_list2, EEG2] = set_epoch(EEG,eventstr)

%eeglab-function for producing epochs
EEG2 = pop_epoch( EEG, {eventstr}, [0    0.09], 'newname', 'epochs', 'epochinfo', 'yes');

%----normalize Data-----
[x_norm, y_norm] = normalize(EEG2.data);

%-----choose right trigger with thresholds-----
if strcmp(eventstr,'100')
    thresTarget =  -0.95;
    thresOrigin =  -0.05;
else
    thresTarget =  -0.05; %target
    thresOrigin =  -0.95; %origin
    
end
%output
[raise_time_list1, reaction_time_list1] = find_raisetime_gen(thresTarget, thresOrigin, x_norm, EEG2.times);
[raise_time_list2, reaction_time_list2] = find_raisetime_gen(thresTarget, thresOrigin, y_norm, EEG2.times);
