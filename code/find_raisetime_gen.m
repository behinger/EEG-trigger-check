function [raise_time,reaction_time] = find_raisetime_gen(thresTarget, thresOrigin, data, EEG_time)

%origin color
samples_Origin = nan(1,size(data,3));
if thresOrigin > thresTarget
    data_Origin = data(:,:,:)<thresOrigin;
else
    data_Origin = data(:,:,:)>thresOrigin;
end

for ep = 1:size(data,3)
    for k = 1:size(data,2)
        if data_Origin(1,k,ep) == 1
            data_Origin(1,k,ep) = 0;
        else
            break
        end
    end
    if ~any(data_Origin(1,:,ep))
       warning('At least in one epoch, I could not find a sample greater/lower than Threshold2')
        continue
    end        
   samples_Origin(ep) = find(data_Origin(1,:,ep),1,'first');

end

% Target color
samples_Target = nan(1,size(data,3));
if thresOrigin > thresTarget
    data_Target = data(:,:,:)<thresTarget;
else
    data_Target = data(:,:,:)>thresTarget;
end
    
for ep = 1:size(data,3)
    for k = 1:size(data,2)
        if data_Target(1,k,ep) == 1
            data_Target(1,k,ep) = 0;
        else
            break
        end
    end
    if ~any(data_Target(1,:,ep))
       warning('At least in one epoch, I could not find a sample greater/lower than Threshold1')
        continue
    end
    
    samples_Target(ep) = find(data_Target(1,:,ep),1,'first');
end

nanidx = isnan(samples_Origin) | isnan(samples_Target);
samples_Origin(nanidx) = [];
samples_Target(nanidx) = [];
% define output
if thresOrigin > thresTarget
    raise_time = EEG_time(samples_Target) - EEG_time(samples_Origin);
    reaction_time = EEG_time(samples_Origin);
else 
    raise_time = EEG_time(samples_Target) - EEG_time(samples_Origin);
    reaction_time = EEG_time(samples_Origin);
end