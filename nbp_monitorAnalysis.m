% EEG = pop_fileio('/net/store/nbp/EEG/blind_spot/data/monitorSpeedCheck/benq120Hz/120hz gabor.cnt');
addpath('c:\users\behinger\Dropbox\phD\opto\scripts\toolbox\eeglab_git\')
eeglab rebuild
addpath('e:\anteepimport1.10\')
addpath('e:\')
% EEG = pop_select( EEG,'channel',{'IMAGEN'});
% EEG = pop_loadeep('e:\20150925_1608.cnt','triggerfile','on');
% EEG = pop_loadeep('e:\whiteBasis2.cnt','triggerfile','on');
%  EEG = pop_loadeep('e:\triggerCheckerLong.cnt','triggerfile','on');
 EEG = pop_loadeep('e:\led_test.cnt','triggerfile','off');
 EEG = pop_loadeep('e:\luminancev2_2.cnt','triggerfile','on');
EEG.data = EEG.data - mean(EEG.data); % remove crazy dc offset

EEG.data = detrend(EEG.data);

%% 50 Hz
figure,pwelch(EEG.data,[],[],[],2048)
% --> lets filter

%EEG = pop_eegfiltnew(EEG,48,52,[],1,0,1);
pwelch(EEG.data(1,200000:end),[],[],[],2048)
%%
EEG2 = pop_epoch( EEG, {'10'}, [-0.05         0.05], 'newname', 'epochs', 'epochinfo', 'yes');

EEG2 = pop_rmbase( EEG2, [-50   0]);

% EEG = pop_eegfiltnew(EEG, 10, [])
% EEG = pop_select( EEG,'notrial',[1:200] );

% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname','EPOCHS','gui','off'); 
% eeglab redraw
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