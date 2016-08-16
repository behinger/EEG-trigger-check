function [x_norm, y_norm] = normalize(EEG2_data)
    

x_on_zero = EEG2_data(1,:,:) - (max(EEG2_data(1,:)));
y_on_zero = EEG2_data(3,:,:) - (max(EEG2_data(3,:)));

x_norm = x_on_zero / abs(min(x_on_zero(:)));
y_norm = y_on_zero / abs(min(y_on_zero(:)));