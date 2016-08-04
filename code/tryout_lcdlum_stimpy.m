% EEG = pop_fileio('/net/store/nbp/EEG/blind_spot/data/monitorSpeedCheck/benq120Hz/120hz gabor.cnt');
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

  EEG = pop_loadset('/home/experiment/lcdlum/data/rand.set');
%EEG = pop_loadeep('data/grayvalues.cnt','triggerfile','on');

eeglab redraw

% parting of EEG Data into epochs
%EEG2 = pop_epoch( EEG, {'100'}, [-0.05         0.05], 'newname', 'epochs', 'epochinfo', 'yes');
EEG2 = pop_epoch( EEG, {'100'}, [0         0.05], 'newname', 'epochs', 'epochinfo', 'yes');
% plotting normalized data
figure

hold all
x_on_zero = EEG2.data(1,:,:) - (max(EEG2.data(1,:)));
y_on_zero = EEG2.data(3,:,:) - (max(EEG2.data(3,:)));

x_norm = x_on_zero / abs(min(x_on_zero(:)));
y_norm = y_on_zero / abs(min(y_on_zero(:)));

x = plot(EEG2.times,squeeze(x_norm),'r');
y = plot(EEG2.times,squeeze(y_norm),'g');
    
    
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

for i = 1:length(y)
    y(i).Color(4) = 0.1;
end

% title + label
title('white-black-white-switch')
xlabel('time')
ylabel('voltage')


%%
threshBlack =  -0.01;
threshWhite =  -0.99;

%<>
% raise time for black
x_black = x_norm(:,:,1)<threshBlack;
for j = 1:max(size(x_norm),3)
    for k = 1:length(x_black)
        if x_black(k) == 1
            x_black(k) = 0;
        else
            break
        end
    end
end
y_black = y_norm(:,:,1)<threshBlack;
for j = 1:size(y_norm,3)
    for k = 1:length(y_black)
        if y_black(k) == 1
            y_black(k) = 0;
        else
            break
        end
    end
end

% raise time for white

x_white = x_norm(:,:,1)<threshWhite;
for j = 1:max(size(x_norm),3)
    for k = 1:length(x_white)
        if x_white(k) == 1
            x_white(k) = 0;
        else
            break
        end
    end
end

y_to_white = nan(1,size(y_norm,3));
y_white = y_norm(:,:,:)<threshWhite;
for ep = 1:size(y_norm,3)
    for k = 1:size(y_norm,2)
        if y_white(1,k,ep) == 1
            y_white(1,k,ep) = 0;
        else
            break
        end
    end
    
    y_to_white(ep) = find(y_white(1,:,ep),1,'first');

end


x_from_black = find(x_black,1,'first');



y_from_black = find(y_black,1,'first');
y_to_white = find(y_white,1,'first');

raise_time_x = EEG2.times(x_to_white) - EEG2.times(x_from_black)
raise_time_y = EEG2.times(y_to_white) - EEG2.times(y_from_black)


% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname','EPOCHS','gui','off'); 
% eeglab redraw
print(sprintf('figures/%s_white2black.png',dataset),'-dpng')
%%mDat = mean(EEG2.data,3);
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