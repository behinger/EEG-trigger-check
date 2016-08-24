function [t_all_events] = tryout_lcdlum_ulelap(monitor,eventstrcell,thres, currentMonitor,USE_PLOT)


% EEG = pop_loadset(monitor);
% EEG = pop_loadset('C:\Users\Ule\Desktop\Programmier-Kram\EEG-trigger-check-master\data\eeglabsets\benq120hz.set');
   %%-----if the channels are not 1 and 2 but 1 and 3, this line changes the channel 3 to channel 2
%EEG = pop_loadset('/home/experiment/lcdlum/eeg_data/benq120hz.set');
EEG = pop_loadeep(monitor,'triggerfile','on');

%eeglab redraw
%%
%-----parting of EEG Data into epochs------

for e = 1:length(EEG.event)
    EEG.event(e).type = deblank(EEG.event(e).type);    %nimmt komisches zeichen aus EEG.event raus
end

t_all_events = [];
for eventstridx = eventstrcell   
    eventstr = eventstridx{1};
    [raise_time_list1, reaction_time_list1,raise_time_list2, reaction_time_list2, EEG2] = set_epoch_2(EEG,eventstr,thres);  %set_epoch is also normalizing
    
    
    
    %EEG2 = pop_epoch( EEG, {'100'}, [-0.05    0.15], 'newname', 'epochs', 'epochinfo', 'yes');
    
    %%
    %-----plotting data-----
    
    %----normalize Data-----
    [x_norm, y_norm] = normalize(EEG2.data);
    
    if USE_PLOT;
        figure, hold all
        
        x = plot(EEG2.times,squeeze(x_norm),'r');
        y = plot(EEG2.times,squeeze(y_norm),'g');
        
        %transparency
        for i = 1:length(x)
            x(i).Color(4) = 0.1;
        end
        for i = 1:length(y)
            y(i).Color(4) = 0.1;
        end
        
        % title + label
        if strcmp(eventstridx,'10');
            swit = 'gray2black';
        elseif strcmp(eventstridx,'20');
            swit = 'black2gray';
        elseif strcmp(eventstridx,'30');
            swit = 'gray2white';
        elseif strcmp(eventstridx,'40');
            swit = 'white2black';
        elseif strcmp(eventstridx,'50');
            swit = 'black2white';
        elseif strcmp(eventstridx,'60');
            swit = 'white2gray';
        elseif strcmp(eventstridx,'101');
            swit = 'before long white2black';
        elseif strcmp(eventstridx,'102');
            swit = 'before long black2gray';
        elseif strcmp(eventstridx,'103');
            swit = 'before long gray2white';
        elseif strcmp(eventstridx,'201');
            swit = 'after long black';
        elseif strcmp(eventstridx,'202');
            swit = 'after long gray';
        elseif strcmp(eventstridx,'203');
            swit = 'after long white';
        elseif strcmp(eventstridx,'66');
            swit = 'fast flipping white2black'
        elseif strcmp(eventstridx,'67');
            swit = 'fast flippin black2white'
        else
            swit = ''
        end
        
        title(['Switch', eventstridx, swit])
        xlabel('time')
        ylabel('voltage')
        
        % 10 --> g2b
        % 20 --> b2g
        % 30 --> g2w
        % 40 --> w2b
        % 50 --> b2w
        % 60 --> w2g
        
        % plotting means of data-channels
        mDat_x = mean(squeeze(x_norm),2);
        mDat_y = mean(squeeze(y_norm),2);
        
        
        plot(EEG2.times,mDat_x,'b')
        plot(EEG2.times,mDat_y,'b')
        
    end
 
    
    %%
    %-----raise_time, reaction_time, response_time-----
    
    
    % parameter are already produced in set_epoch-function
    response_time_list1 = raise_time_list1 + reaction_time_list1;
    response_time_list2 = raise_time_list2 + reaction_time_list2;
    
    raise_time_mean1 = mean(raise_time_list1);
    raise_time_mean2 = mean(raise_time_list2);
    
    reaction_mean1 = mean(reaction_time_list1);
    reaction_mean2 = mean(reaction_time_list2);
    
    response_time1_mean = mean(response_time_list1);
    response_time2_mean = mean(response_time_list2);
    
    %%
    %-----delay for response, reaction and raise time-----
    
    delay_response_list = response_time_list1 - response_time_list2;
    delay_reaction_list = reaction_time_list1 - reaction_time_list2;
    delay_raise_list = raise_time_list1 - raise_time_list2;
    
    delay_response_mean = mean(delay_response_list);
    delay_reaction_mean = mean(delay_reaction_list);
    delay_raise_mean = mean(delay_raise_list);
    
    %%
    %-----quantiles of raise-time, reaction-time, response-time------
    
    %quantiles raise-time
    raise_time_quantile1 = quantile(raise_time_list1,[0.05 0.95]);
    raise_time_quantile2 = quantile(raise_time_list2,[0.05 0.95]);
    %quantiles reaction-time
    reaction_time_quantile1 = quantile(reaction_time_list1,[0.05 0.95]);
    reaction_time_quantile2 = quantile(reaction_time_list2, [0.05 0.95]);
    %quantiles response-time
    response_time_quantile1 = quantile(response_time_list1,[0.05 0.95]);
    response_time_quantile2 = quantile(response_time_list2,[0.05 0.95]);
    
    
    %%
    fprintf('\n')
    fprintf('-----Trigger:%s----- \n',eventstr)
    fprintf('Raise-time\n')
    fprintf('Sensor 1: %.1f (%.1f,%.1f) \n',raise_time_mean1,raise_time_quantile1)
    fprintf('Sensor 2: %.1f (%.1f,%.1f) \n',raise_time_mean2,raise_time_quantile2)
    fprintf('\n')
    fprintf('Reaction-time\n')
    fprintf('Sensor 1: %.1f (%.1f,%.1f) \n',reaction_mean1,reaction_time_quantile1)
    fprintf('Sensor 2: %.1f (%.1f,%.1f) \n',reaction_mean2,reaction_time_quantile2)
    fprintf('\n')
    
    %%
    Monitors = [{currentMonitor}; {currentMonitor}];
    Trigger = [eventstridx; eventstridx];
    Sensor = [1;2];
    Raisetime = [raise_time_mean1; raise_time_mean2];
    Reactiontime = [reaction_mean1;reaction_mean2];
    Responsetime = [response_time1_mean;response_time2_mean];
    RaiseQuantileLow = [raise_time_quantile1(1); raise_time_quantile2(1)];
    RaiseQuantileHigh = [raise_time_quantile1(2); raise_time_quantile2(2)];
    ReactionQuantileLow = [reaction_time_quantile1(1);reaction_time_quantile2(1)];
    ReactionQuantileHigh = [reaction_time_quantile1(2);reaction_time_quantile2(2)];
    ResponseQuantileLow = [response_time_quantile1(1);response_time_quantile2(1)];
    ResponseQuantileHigh = [response_time_quantile1(2);response_time_quantile2(2)];
    
    t_single = table(Monitors, Trigger, Sensor, Raisetime, RaiseQuantileLow,...
               RaiseQuantileHigh, Reactiontime, ReactionQuantileLow, ReactionQuantileHigh,...
               Responsetime, ResponseQuantileLow, ResponseQuantileHigh);
    
%     t_single_event = table([reaction_mean1,reaction_mean2]', ...
%                            [reaction_time_quantile1(1),reaction_time_quantile2(1)]',...
%                            [1,2]',...
%                            repmat(eventstridx,2,1),'VariableNames',{'reactiontime','reactiontimeLow','sensor','event'});   
    t_all_events = [t_all_events; t_single];
end























