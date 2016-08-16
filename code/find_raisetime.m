function [raise_time,reaction_time] = find_raisetime(thresWhite, thresBlack, data, EEG_time)

% from black
samples_b = nan(1,size(data,3));
data_from_black = data(:,:,:)<thresBlack;
for ep = 1:size(data,3)
    for k = 1:size(data,2)
        if data_from_black(1,k,ep) == 1
            data_from_black(1,k,ep) = 0;
        else
            break
        end
    end
    
   samples_b(ep) = find(data_from_black(1,:,ep),1,'first');

end

% to white
samples_w = nan(1,size(data,3));
data_to_white = data(:,:,:)<thresWhite;
for ep = 1:size(data,3)
    for k = 1:size(data,2)
        if data_to_white(1,k,ep) == 1
            data_to_white(1,k,ep) = 0;
        else
            break
        end
    end
    
    samples_w(ep) = find(data_to_white(1,:,ep),1,'first');

end




raise_time = EEG_time(samples_w) - EEG_time(samples_b);
reaction_time = EEG_time(samples_b);

