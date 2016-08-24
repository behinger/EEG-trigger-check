
init_paths

% epoching data

monitor = 'data/audio_visual_test';


EEG = pop_loadeep(monitor,'triggerfile','on');


EEG2 = pop_epoch( EEG, {'128'}, [0    0.25], 'newname', 'epochs', 'epochinfo', 'yes');
EEG2 = eeg_checkset(EEG2);

x_norm = EEG2.data(1,:,:);
y_norm = EEG2.data(5,:,:);


%plotting data

figure, hold all

x = plot(EEG2.times,squeeze(x_norm),'r');
y = plot(EEG2.times,squeeze(y_norm),'g');


for i = 1:length(x)
    x(i).Color(4) = 0.1;
end
for i = 1:length(y)
    y(i).Color(4) = 1;
end


mDat_x = mean(squeeze(x_norm),2);
mDat_y = mean(squeeze(y_norm),2);


plot(EEG2.times,mDat_x,'b')
plot(EEG2.times,mDat_y,'b')

%% calculating diffrences
sound_max = nan(1,size(EEG2.data,3));
for ep = 1:size(EEG2.data,3);
    [~,idx] = max(EEG2.data(5,:,ep));
    sound_max(ep) = idx;
end

vis_max = nan(1,size(EEG2.data,3));
for ep = 1:size(EEG2.data,3);
    vis_max(ep) = find(EEG2.data(1,:,ep) < -9950,1,'first');
end
myList = EEG2.times(sound_max) - EEG.times(vis_max); %list with diffrences for every epoch



figure
hist(myList,40)










