%EEG = pop_fileio('/net/store/nbp/EEG/blind_spot/data/monitorSpeedCheck/benq120Hz/120hz gabor.cnt');



%-----choose between windows and linux-----
if ispc
    p.eeglab = 'C:\Users\Ule\Desktop\Programmier-Kram\EEG-trigger-check-master\eeglab13_6_5b';
    p.anteepimport = 'C:\Users\Ule\Desktop\Programmier-Kram\EEG-trigger-check-master\lib\anteepimport1.10';
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

%eeglab rebuild
addpath(p.anteepimport)
addpath('lib')
%dataset = '/home/experiment/lcdlum/EEG-trigger-check/Test run/rand/20160802_1450.cnt'



%------------------YOU HAVE TO ENTER THE FOLLOWING PARAMETERS--------------



%-----names of triggers-----
eventstrcell = {'5','95'};

%-----threshold: fix or variable?
thres = 'nonfix';


%-----choose the monitordata-----
% monitor = 'C:\Users\Ule\Desktop\Programmier-Kram\EEG-trigger-check-master\data\eeglabsets/rand.set'

monitor = 'C:\Users\Ule\Desktop\Programmier-Kram\EEG-trigger-check-master\data\eeglabsets\benq120hz.set'
%monitor2 =
%monitor3 = 
%monitor4 =
%monitor5 =





%-------------------Execution----------------------
[raise_time_mean1, raise_time_quantile1] = tryout_lcdlum_ulelap(monitor,eventstrcell,thres);






