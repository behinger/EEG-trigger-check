%% Init scripts
git_path_list = {{'C:\Users\Ule\Desktop\Programmier-Kram\EEG-trigger-check-master\','eeglab13_6_5b'}
    {'/net/store/nbp/projects/lcdlum/git/','../eeglab'}
    {'C:\Users\behinger\cloud\PhD\exercises\lcdlum\','../../lib/eeglab'}};
git_path = [];
for p = git_path_list'
    if exist(p{1}{1},'dir')
        git_path = p{1}{1};
        eeglab_path = p{1}{2};
        break
    end
end
if isempty(git_path)
    error('could not find path')
end

cd(git_path) % we use some relative paths further down. Thus we have to change to the folder
addpath([git_path eeglab_path]) % add eeglab

% this adds the ant importer scripts
if ispc
    addpath([git_path 'lib\anteepimport1.10'])
else
    addpath('/net/store/nbp/projects/lib/anteepimport1.09/') % for unix we need a different anteepimport
end

addpath([git_path 'code'])
addpath([git_path 'lib'])

 %check whether eeglab was started already
if ~exist('eeg_checkset','file')
    eeglab rebuild
end

