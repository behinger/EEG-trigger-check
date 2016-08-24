


init_paths % init paths for eeglab anteepimport and so on



%------------------YOU HAVE TO ENTER THE FOLLOWING PARAMETERS--------------



%-----names of triggers-----
% eventstrcell = {'10','20','30','40','50','60','101','102','103','201','202','203','66','67'};
% eventstrcell = {'1','2','3'};
% eventstrcell = {'10','20','30','40','50','60','66','67'}
eventstrcell = {'10'};

%-----threshold: fix or variable?
thres = 'nonfix'; %"fix" or not fix

%-----plot?-----
USE_PLOT = 1;


%-----choose the monitor, if not every monitor wanted-----


% monitor = 'C:\Users\Ule\Desktop\Programmier-Kram\EEG-trigger-check-master\data\eeglabset\rand.set'
% monitor = 'C:\Users\Ule\Desktop\Programmier-Kram\EEG-trigger-check-master\data\eeglabsets\benq120hz.set'
% monitor = '/net/store/nbp/projects/lcdlum/EEG-trigger-check-master/data/eeglabsets/rand.set'
% monitor = '/net/store/nbp/projects/lcdlum/EEG-trigger-check-master/data/eeglabsets/benq120hz.set'
% monitor = 'data/Recordings_lcdlum/Apple_60hz.cnt'


myMonitors = {'Apple_60hz.cnt','Apple_60hz_max.cnt','Apple_60hz_min.cnt', 'Asus32_60hz.cnt', 'Benq1_60hz.cnt', 'Benq1_120hz.cnt', ...
    'Benq2_60hz.cnt','Benq2_120hz.cnt', 'Benq2_120hz_noAMA.cnt', 'Benq2_120hz_noInstant.cnt', ...
    'Benq2_120hz_noAMAnoInstant.cnt', 'Benq144_60hz.cnt', 'Benq144_120hz.cnt', ...
    'Benq144_144hz.cnt', 'SamsungSyncMaster.cnt'};
%-----Execution every Monitor-----
monitorVar = 'data/Recordings_lcdlum/'  ; % current folder have to be Recordings_lcdlum!


t_all_monitor = []
%calling function like that for tabled-data-structure
for i = 1:3; %length(myMonitors);
    monitor = [monitorVar, myMonitors{i}];
    currentMonitor = myMonitors{i}(1:end-4);
    [t_all_events] = tryout_lcdlum_ulelap(monitor,eventstrcell,thres, currentMonitor, USE_PLOT);

    t_all_monitor = [t_all_monitor; t_all_events];
end





%-----CHECK IN tryout_lcdlum_m IF CHANNEL 3 = CHANNEL 2-----



%-------------------Execution just one Monitor---------------------

%check that monitor = 'data/Recordings_ldclum/monitorfile.cnt'


% [raise_time_mean1, raise_time_quantile1] = tryout_lcdlum_ulelap(monitor,eventstrcell,thres);



t_all_monitor %parameters of t_all_monitor : (Monitors, Trigger, Sensor, Raisetime, RaiseQuantileLow, RaiseQuantileHigh, Reactiontime, ReactionQuantileLow, ReactionQuantileHigh

figure
g = gramm('x', t_all_monitor.Monitors, 'y', t_all_monitor.Raisetime);
g.facet_grid([], t_all_monitor.Trigger);
g.geom_point();
g.stat_boxplot();
g.set_names('x', 'Monitor','y','Raisetime in ms');
g.set_title('Raisetimes of monitors')
g.draw();









