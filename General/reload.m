% Save workspace in temporary file, clear everything, reload.  This is
% useful when you have an objects whose method declarations have changed.

u2432432=userpath;

fileadadagfd=[u2432432(1:end-1) filesep 'ReloadTemp.mat'];

save('fileadadagfd'); 

close all hidden; clear classes -except fileadadagfd; clc;

load('fileadadagfd');


clearvars fileadadagfd u2432432

% 
% evalin('base',['save ''' file '''; close all hidden; clear classes; clc;']);
% 
% evalin('base',['load ''' file ''';']);
% 
