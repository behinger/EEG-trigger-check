% EEG = pop_fileio('/net/store/nbp/EEG/blind_spot/data/monitorSpeedCheck/benq120Hz/120hz gabor.cnt');
if ispc
    p.eeglab = genpath('c:\users\behinger\Dropbox\phD\opto\scripts\toolbox\eeglab_git\');
    p.anteepimport = 'anteepimport1.10';
else
    p.eeglab = genpath('~/Documents/MATLAB/eeglab_dev/');
    p.anteepimport = '/net/store/nbp/projects/lib/anteepimport1.09/';
end
addpath(p.eeglab)

%eeglab rebuild
addpath(p.anteepimport)
addpath('data')
addpath('lib')
% EEG = pop_select( EEG,'channel',{'IMAGEN'});
% EEG = pop_loadeep('data/20150925_1608.cnt','triggerfile','on');
% EEG = pop_loadeep('data/whiteBasis2.cnt','triggerfile','on');
  EEG = pop_loadeep('data/triggerCheckerLong.cnt','triggerfile','on');
%  EEG = pop_loadeep('data/led_test.cnt','triggerfile','off');
%  EEG = pop_loadeep('data/luminancev2_2.cnt','triggerfile','on');
%EEG = pop_loadeep('data/grayvalues.cnt','triggerfile','on');
EEG.data = EEG.data - mean(EEG.data); % remove crazy dc offset

% EEG.data = detrend(EEG.data);

%% 50 Hz
figure,pwelch(EEG.data,[],[],[],2048)
% --> lets filter

EEG = pop_eegfiltnew(EEG,46,54,[],1,0,1);
% EEG = pop_eegfiltnew(EEG,640,660,[],1,0,1);
pwelch(EEG.data(1,200000:end),[],[],[],2048)
%%
EEG2 = pop_epoch( EEG, {'40'}, [-0.05         0.05], 'newname', 'epochs', 'epochinfo', 'yes');

EEG2 = pop_rmbase( EEG2, [-50   0]);

% EEG = pop_eegfiltnew(EEG, 10, [])
% EEG = pop_select( EEG,'notrial',[1:200] );
mDat = mean(EEG2.data,3);
figure

hold all
x = plot(EEG2.times,squeeze(EEG2.data));
for i =1:length(x)
x(i).Color(4) = 0.1;
end
vline(EEG2.times(find(mDat>45,1,'first')))
plot(EEG2.times,mDat,'b','LineWidth',2),vline(0)
title(['white2black: ',num2str(EEG2.times(find(mDat>45,1,'first'))),' ms'])
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname','EPOCHS','gui','off'); 
% eeglab redraw
print('figures/triggerCheckerLong_white2black.png')
%%
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
% EEG2 = pop_rmbase( EEG2, [-0.5   0]);
% m = squeeze(mean(EEG2.data,3));
% sd = squeeze(std(EEG2.data,[],3));
% shadedErrorBar(EEG2.times,m,sd,[],1)

% plot(EEG2.times,squeeze(EEG2.data),'Color',colorlist(ev/10,:))
end
%%
figure,errorbar(mean(dat(2:end,1:102),2),range(dat(2:end,1:102)'))
set(gca,'XTick',[0,32,128])
set(gca,'XtickLabel',{'Black','64/255','White'})