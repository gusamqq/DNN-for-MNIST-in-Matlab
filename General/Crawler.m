function [paths files]=crawler(rootpath,expr)
% Search for MAT files in a given folder

if ~exist('expr','var'), expr='*.mat'; end

% rootpath='\\132.216.58.109\Drobo (E)\ElectroPhys\Analyzed Data';



paths=getpaths(rootpath);


if nargout>1, 
    
    files=getfiles(paths,expr); 
    
end



end


function paths=getpaths(rootpath)

    pathlist=genpath(rootpath);

    if ispc
        t=textscan(pathlist,'%s','delimiter',';');
    else
        t=textscan(pathlist,'%s','delimiter',':');
    end
    paths=t{1};
        
%     semis=[0 find(pathlist==';')];
% 
%     paths=cell(length(semis)-1,1);
%     for i=1:length(semis)-1
%         paths{i}=pathlist(semis(i)+1:semis(i+1)-1);
%     end

end


function files=getfiles(paths,type)
    oldcd=cd;
    files={};
    for i=1:length(paths)
        cd (paths{i});
        try 
            ss=ls(type);
            
        catch ME
            switch ME.identifier
                case 'MATLAB:ls:OSError'
                    continue;
                otherwise
                    rethrow(ME);
            end
        end
%         st=what(paths{i});
%         if isempty(ss), continue; end
        sss=regexp(ss,'\s*','split');
        files=[files;  strcat(paths{i}, filesep, sss(~cellfun(@isempty,sss))')];

    end
    cd(oldcd);
end
