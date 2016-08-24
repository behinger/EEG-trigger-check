


init_paths % init paths for eeglab anteepimport and so on



%------------------YOU HAVE TO ENTER THE FOLLOWING PARAMETERS--------------



%-----names of triggers-----
% eventstrcell = {'10','20','30','40','50','60','101','102','103','201','202','203','66','67'};
% eventstrcell = {'1','2','3'};
eventstrcell = {'10','20','30','40','50','60'}
% eventstrcell = {'10','20'};

%-----threshold: fix or variable?
thres = 'nonfix'; %"fix" or not fix

%-----plot?-----
USE_PLOT = 0;


%-----choose the monitor, if not every monitor wanted-----


% monitor = 'C:\Users\Ule\Desktop\Programmier-Kram\EEG-trigger-check-master\data\eeglabset\rand.set'
% monitor = 'C:\Users\Ule\Desktop\Programmier-Kram\EEG-trigger-check-master\data\eeglabsets\benq120hz.set'
% monitor = '/net/store/nbp/projects/lcdlum/EEG-trigger-check-master/data/eeglabsets/rand.set'
% monitor = '/net/store/nbp/projects/lcdlum/EEG-trigger-check-master/data/eeglabsets/benq120hz.set'
% monitor = 'data/Recordings_lcdlum/Apple_60hz.cnt'


myMonitors = {'Apple_60hz_max.cnt', 'Asus32_60hz.cnt', 'Benq1_60hz.cnt', 'Benq1_120hz.cnt', ...c
    'Benq2_60hz.cnt','Benq2_120hz.cnt','Benq144_60hz.cnt', 'Benq144_120hz.cnt', ...
    'Benq144_144hz.cnt',};
%-----Execution every Monitor-----
monitorVar = 'data/Recordings_lcdlum/'  ; % current folder have to be Recordings_lcdlum!


t_all_monitor = [];
%calling function like that for tabled-data-structure
for i = 1:length(myMonitors);
    monitor = [monitorVar, myMonitors{i}];
    currentMonitor = myMonitors{i}(1:end-4);
    [t_all_events] = tryout_lcdlum_ulelap(monitor,eventstrcell,thres, currentMonitor, USE_PLOT);

    t_all_monitor = [t_all_monitor; t_all_events];
end





%-----CHECK IN tryout_lcdlum_m IF CHANNEL 3 = CHANNEL 2-----



%-------------------Execution just one Monitor---------------------

%check that monitor = 'data/Recordings_ldclum/monitorfile.cnt'


% [raise_time_mean1, raise_time_quantile1] = tryout_lcdlum_ulelap(monitor,eventstrcell,thres);



t_all_monitor %parameters of t_all_monitor : (Monitors, Trigger, Sensor, Raisetime, RaiseQuantileLow, RaiseQuantileHigh, Reactiontime, ReactionQuantileLow, ReactionQuantileHigh, Responsetime, ResponseQuantileLow, ResponseQuantileHigh)
%%
addpath('lib/gramm');



figure
%,'RaiseQuantileLow','ReactionQuantileLow','RaiseQuantileHigh','ReactionQuantileHigh'
t_stacked = stack(t_all_monitor,{'Raisetime','Reactiontime','Responsetime'},...
            'IndexVariableName','Type','NewDataVariableName','MeanTime');
%x = t_stacked{1:2:end,{'ReactionQuantileLow','RaiseQuantileLow'}}';
x = t_stacked{1:3:end,{'RaiseQuantileLow','ReactionQuantileLow','ResponseQuantileLow'}}';
t_stacked.QuantileLow = x(:);
x = t_stacked{1:3:end,{'RaiseQuantileHigh','ReactionQuantileHigh','ResponseQuantileHigh'}}';
t_stacked.QuantileHigh = x(:);


t_stacked =  t_stacked(:,[1:3 8:end]);

color_dict = {'g2b','b2g','g2w','w2b','b2w','w2g'};
t_stacked.Color =  color_dict(cellfun(@(x)str2num(x),t_stacked.Trigger)/10)';
% 10 --> g2b
% 20 --> b2g
% 30 --> g2w
% 40 --> w2b
% 50 --> b2w
% 60 --> w2g

g = gramm('x', t_stacked.Monitors,'y',t_stacked.MeanTime, ...
    'ymax', t_stacked.QuantileHigh,'ymin',t_stacked.QuantileLow,'color',t_stacked.Color);
g.facet_grid(t_stacked.Type, t_stacked.Sensor);
g.geom_point('dodge',0.7)
g.geom_interval('geom','errorbar','dodge',0.7)
% g.stat_boxplot();
g.set_names('column','Sensor','x', 'Monitor','y',' ms');
g.set_title('Raisetimes & Reactiontimes of Monitors')
g.draw();









