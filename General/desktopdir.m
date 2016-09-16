function di=desktopdir(extension)

if ~exist('extension','var'), extension=''; end

ud=userpath;
di=[ud(1:find(ud==filesep,2,'last')) 'Desktop' filesep extension];

if ~isdir(di)
    di=userpath;
    if di(end)==':'
        di(end)=[];
    end
end



