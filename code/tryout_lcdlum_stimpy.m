%EEG = pop_fileio('/net/store/nbp/EEG/blind_spot/data/monitorSpeedCheck/benq120Hz/120hz gabor.cnt');
if ispc
    p.eeglab = genpath('c:\users\behinger\Dropbox\phD\opto\scripts\toolbox\eeglab_git\');
    p.anteepimport = 'anteepimport1.10';
else
    cd /home/experiment/lcdlum/EEG-trigger-check/
    p.eeglab = '/home/experiment/lcdlum/eeglab';
    p.anteepimport = '/home/experiment/lcdlum/libeep-3.3.173/share/libeep/matlab';
%else
%    cd /net/store/nbp/projects/lcdlum/scripts/EEG-trigger-check/
%    p.eeglab = '/net/store/nbp/projects/lcdlum/lib/eeglab';
%    p.anteepimport = '/net/store/nbp/projects/lib/anteepimport1.09/';
end
addpath(p.eeglab)

eeglab rebuild
addpath(p.anteepimport)
addpath('lib')
%dataset = '/home/experiment/lcdlum/EEG-trigger-check/Test run/rand/20160802_1450.cnt'

EEG = pop_loadset('/home/experiment/lcdlum/eeg_data/rand.set');
%EEG = pop_loadset('/home/experiment/lcdlum/eeg_data/benq120hz.set');
%EEG = pop_loadeep('data/grayvalues.cnt','triggerfile','on');

eeglab redraw

% parting of EEG Data into epochs

%EEG2 = pop_epoch( EEG, {'100'}, [-0.05    0.05], 'newname', 'epochs', 'epochinfo', 'yes');
%EEG2 = pop_epoch( EEG, {'95'}, [-0.03   0.09], 'newname', 'epochs', 'epochinfo', 'yes');
for e = 1:length(EEG.event)
    EEG.event(e).type = deblank(EEG.event(e).type);
end
EEG2 = pop_epoch( EEG, {'100'}, [0    0.09], 'newname', 'epochs', 'epochinfo', 'yes');
% plotting normalized data

%% 
%-----plotting normalized data-----
figure

hold all
x_on_zero = EEG2.data(1,:,:) - (max(EEG2.data(1,:)));
y_on_zero = EEG2.data(3,:,:) - (max(EEG2.data(3,:)));

x_norm = x_on_zero / abs(min(x_on_zero(:)));
y_norm = y_on_zero / abs(min(y_on_zero(:)));

x = plot(EEG2.times,squeeze(x_norm),'r');
y = plot(EEG2.times,squeeze(y_norm),'g');
    
%transparency   
for i = 1:length(x)
    x(i).Color(4) = 0.1;
end
for i = 1:length(y)
    y(i).Color(4) = 0.1;
end

title('white-black-white-switch')
xlabel('epoch')
ylabel('voltage')



% plotting means of data-channels
mDat_x = mean(squeeze(x_norm),2);
mDat_y = mean(squeeze(y_norm),2);


plot(EEG2.times,mDat_x,'b')
plot(EEG2.times,mDat_y,'b')



% title + label
title('white-black-white-switch')
xlabel('time')
ylabel('voltage')


%%


% if thr1  < thr2
%    a < thr
% elseif strcmp(type,'greater')
%     a !< thr
% end

%-----raise_time, reaction_time, response_time-----
thresWhite =  -0.99;
thresBlack =  -0.01;

[raise_time_list1, reaction_time_list1] = find_raisetime(thresWhite, thresBlack, x_norm, EEG2.times);
[raise_time_list2, reaction_time_list2] = find_raisetime(thresWhite, thresBlack, y_norm, EEG2.times);

response_time1 = raise_time_list1 + reaction_time_list1;
response_time2 = raise_time_list2 + reaction_time_list2;


raise_mean1 = mean(raise_time_list1)
raise_mean2 = mean(raise_time_list2)

reaction_mean1 = mean(reaction_time_list1)
reaction_mean2 = mean(reaction_time_list2)

response_time1_mean = mean(response_time1)
response_time2_mean = mean(response_time2)

%%
%-----delay for response, reaction and raise time-----

delay_response_list = response_time1 - response_time2;
delay_reaction_list = reaction_time_list1 - reaction_time_list2;
delay_raise_list = raise_time_list1 - raise_time_list2;

delay_response_mean = mean(delay_response_list)
delay_reaction_mean = mean(delay_reaction_list)
delay_raise_mean = mean(delay_raise_list)

%%transparancy 
%-----quantiles of raise-time, reaction-time, response-time------

%quantiles raise-time
raise_time_quantile1 = quantile(raise_time_list1,[0.05 0.95])
raise_time_quantile2 = quantile(raise_time_list2,[0.05 0.95])
%quantiles reaction-time
reaction_time_quantile1 = quantile(reaction_time_list1,[0.05 0.95])
reaction_time_quantile2 = quantile(reaction_time_list2, [0.05 0.95])
%quantiles response-time
response_time_quantile1 = quantile(response_time1,[0.05 0.95])
response_time_quantile2 = quantile(response_time2,[0.05 0.95])


%%
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname','EPOCHS','gui','off'); 
% eeglab redraw
print(sprintf('figures/%s_white2black.png',dataset),'-dpng')
%%mDat = mean(EEG2.data,3);transparancy 
figure; pop_erpimage(EEG2,1, [1],[[]],'IMAGEN',1,1,{},[],'' ,'yerplabel','\muV','erp','on','limits',[NaN NaN NaN NaN NaN NaN NaN NaN],'cbar','on','topo', { [1] EEG.chanlocs EEG.chaninfo } );


%%
figure,hold all
colorlist = jet(6);
% 10 --> gray  2 black
% 20 --> black 2 gray
% 30 --> gray  2 white
% 40 --> white 2 black
% 50 --> black 2 white
% 60 --> white 2 gray
for ev = [60];%[40 50]
EEG2 = pop_epoch( EEG, {num2str(ev)}, [-0.05         0.05], 'newname', 'epochs', 'epochinfo', 'yes');
% EEG2 = pop_rmbase( EEG2, [-0.5   0]);
m = squeeze(mean(EEG2.data,3));
sd = squeeze(std(EEG2.data,[],3));
% shadedErrorBar(EEG2.times,m,sd,[],1)

plot(EEG2.times,squeeze(EEG2.data),'Color',colorlist(ev/10,:))
end

%%
m = [];
sd = [];
dat = [];
for k=1:length(EEG.event);EEG.event(k).type = deblank(EEG.event(k).type);end
for ev = [1:128];%[40 50]
EEG2 = pop_epoch( EEG, {num2str(ev)}, [0,0.05], 'newname', 'epochs', 'epochinfo', 'yes');
EEG2.data = EEG2.data(:,:,1:7);
m(ev) = mean(EEG2.data(:));
sd(ev) = std(EEG2.data(:));
dat(ev,:) = EEG2.data(:);
% EEG2 = pop_rmbase( EEmDat = mean(EEG2.data,3);G2, [-0.5   0]);
% m = squeeze(mean(EEG2.data,3));
% sd = squeeze(std(EEG2.data,[],3));
% shadedErrorBar(EEG2.times,m,sd,[],1)

% plot(EEG2.times,squeeze(EEG2.data),'Color',colorlist(ev/10,:))
end
%%
figure,errorbar(mean(dat(2:end,1:102),2),range(dat(2:end,1:102)'))
set(gca,'XTick',[0,32,128])
set(gca,'XtickLabel',{'Black','64/255','White'})