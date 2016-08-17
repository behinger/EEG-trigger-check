function [x_norm, y_norm] = normalize(EEG2_data)

        
        x_norm = -17.4884 + -0.0091 * EEG2_data(1,:,:);
        y_norm = -19.544  + -0.011033 * EEG2_data(2,:,:);
end


