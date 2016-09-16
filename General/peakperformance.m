function [locs pks]=peakperformance(x,cfg)
% [locs pks]=peakperformace(x,minpeakdist,minpeakh,allowEdges)
%
% Alternative to the findpeaks function.  It returns different (and for
% most application better) results than findpeaks, and runs in something
% like NlogN time.
%
% cfg is a configuration structure with fields
% minpeakdist       Minimum Peak separation (in indeces)
% minpeakheight     Minimum Peak height
% allowEdges        Allow peaks within minpeakdist from the edge? (true/false)
% passingRatio      Filter for more "peaked" peaks? 0 has no effect, 1 only leaves a single peak remaining. 
%
% You can also just enter an integer for cfg, in which case it will be read 
% in as the minpeakdist
%
% Example Use:
% x=cos(linspace(0,50,1000))+randn(1,1000)*.2;
% [locs heights]=peakperformance(x,30);    % Find all peaks that are the highest within 30 samples 
% [heights2 locs2]=findpeaks(x,'minpeakdistance',30);
% clf; plot(x); hold all; plot(locs,heights,'*');  plot(locs2,heights2-.05,'*'); 
% legend '' 'peakperformance' 'findpeaks'
% 
% x is a vector input (generally a timecourse)
% minpeakdist is the minimum desired distance between peaks (optional, defaults to 1)
% minpeakh is the minimum height of a peak (optional)
%
% (c) 2010
% Peter O'Connor
% peter<dot>ed<dot>oconnor .AT. gmail<dot>com

% Support shortcut syntax
if isnumeric(cfg)
    cfg=struct('minpeakdist',cfg);
end

setdef('minpeakdist',1);
setdef('minpeakheight',-Inf);
setdef('allowEdges',false);
setdef('passingRatio',0);


if size(x,2)==1, x=x'; end

% Find all maxima and ties
if cfg.minpeakdist>1
    locs=find(x(2:end-1)>=x(1:end-2) & x(2:end-1)>=x(3:end))+1;
    
    edgepeaks=diff([0 locs length(x)])>cfg.minpeakdist;
    
    firstEdgeLocs=edgepeaks(1:end-1);
    lastEdgeLocs=edgepeaks(2:end);
        
    % list of indeces of peaks on losing gaps
    gaplosers=locs(x(locs)<max(1,
    
    % Purge locs that are not greater than the edges of their regions
    loweredges=max(locs-cfg.minpeakdist,1);
    upperedges=min(locs-cfg.minpeakdist,length(x));
    
    locs=locs(x(locs)>x(loweredges) & x(locs)>x(upperedges));
    
    gaps=diff(locs)>cfg.minpeakdist;
    
    
    locs=unique([locs 1:cfg.minpeakdist:length(x)]);
else
    locs=1:length(x);
end








if nargin<2, cfg.minpeakdist=1; end % If no minpeakdist specified, default to 1.

if cfg.minpeakheight>-Inf % If there's a minpeakheight
    locs(x(locs)<=cfg.minpeakheight)=[];
end

% Remove peaks that have no neighbours 

while 1

    % Find all maxima with distance less than minpeakdist
    firstOfPair=find(diff(locs)<=cfg.minpeakdist);

    % If there aren't any, you're done
    if isempty(firstOfPair), break; end

    % Get thr heigths of the current peak locations
    pks=x(locs);

    % Initialize peakscore
    peakScore=zeros(size(locs));

    % Determine winners and losers
    secondOfPair=firstOfPair+1;
    firstPeakLost=pks(firstOfPair)<pks(secondOfPair);

    % Decrement loosing peaks
    peakScore(firstOfPair(firstPeakLost))   = -1;
    peakScore(secondOfPair(~firstPeakLost)) = -1 + peakScore(secondOfPair(~firstPeakLost));

    % Incremement Winning Peaks (bit of a hack here)
    peakScore(firstOfPair(~firstPeakLost))  = +1.1 + peakScore(firstOfPair(~firstPeakLost));
    peakScore(secondOfPair(firstPeakLost))  = +1.1 + peakScore(secondOfPair(firstPeakLost));

    % Still need to worry about lone peaks:


    % Remove peaks with a score below zero
    locs(peakScore<0)=[];

end

end


function passingIndeces=filterPeakRatios(heights,ipms,passingRatio)
% Filter peaks based on a threshold ratio of the height difference between
% each of two neighbouring peaks and the minimum in between.  Basicallt,
% the closer the passingRatio is to 1, the more pronounced and fewer the
% peaks will be.

% vec=zeros(1,length(heights)*2+1); vec(1:2:end)=ipms; vec(2:2:end)=heights;
% splits=diff(vec)>passingRatio*(max(heights)-min(ipms));
% 
thresh=passingRatio*(max(heights)-min(ipms));

passingIndeces=false(size(heights));

currentMin=ipms(1);
currentMax=-Inf;
eligable=false;
for i=1:length(heights)
    
    delUp=heights(i)-currentMin;
    
    
    
    if delUp>thresh
        eligable=true;
        if heights(i)>currentMax
            currentMax=heights(i);
            currentMaxLoc=i;
        end
    end
    
    delDown=currentMax-ipms(i+1);
    
    if delDown>thresh
        if eligable
            % The current max has passed!
            eligable=false;
            passingIndeces(currentMaxLoc)=true;
            currentMax=-Inf;
            currentMin=Inf;
        end
        if ipms(i+1)<currentMin
            currentMin=ipms(i+1);
        end        
    end
    
end

% 
% assert(passingRatio>=0 && passingRatio <= 1, 'Passing Ratio must be in the range [0 1]');
% 
% lowestOfPair=diff(heights)>0;
% 
% ix=1:length(heights)-1;
% 
% % Compute peak ratios
% % ratios=(heights(ix+~lowestOfPair)-ipms)./(heights(ix+lowestOfPair)-ipms);
% 
% ratios=(heights-ipms(1:end-1)).*(heights-ipms(2:end));
% ratios=ratios/max(ratios);
% 
% passingIndeces=ratios>passingRatio;
% 
% if ~all(passingIndeces);
%     % Eliminate the lower of the non-passing peak-pairs
%     
%     heights
%     
%     heights=heights(passingIndeces);
%     
%     
%     
%     heigths(ix+~lowestOfPair)=[];
%     
%     % Take 
% %     ipms=ipms(1+
%     
% %     ipms=
%     
% end
    
    
end

function ipm=findInterPeakMinima(x,locs)

    ipm=nan(1,length(locs)+1);
    
    ipm(1)=min(x(1:locs(1)-1));
    for i=1:length(locs)-1
        ipm(i+1)=min(x(locs(i)+1:locs(i+1)-1));
    end
    ipm(end)=min(x(locs(end)+1:end));
end






% function [locs pks]=peakperformance(x,minpeakdist,minpeakh,allowEdges)
% % Alternative to the findpeaks function.  This thing runs much much faster.
% % It really leaves findpeaks in the dust.  It also can handle ties between
% % peaks.  Findpeaks just erases both in a tie.  
% %
% % x is a vector input (generally a timecourse)
% % minpeakdist is the minimum desired distance between peaks (optional, defaults to 1)
% % minpeakh is the minimum height of a peak (optional)
% %
% % (c) 2010
% % Peter O'Connor
% % peter<dot>ed<dot>oconnor .AT. gmail<dot>com
% 
% if ~exist('allowEdges','var'), allowEdges=false; end;
% 
% if size(x,2)==1, x=x'; end
% 
% % Find all maxima and ties
% locs=find(x(2:end-1)>=x(1:end-2) & x(2:end-1)>=x(3:end))+1;
% 
% if nargin<2, minpeakdist=1; end % If no minpeakdist specified, default to 1.
% 
% if nargin>2 % If there's a minpeakheight
%     locs(x(locs)<=minpeakh)=[];
% end
% 
% if minpeakdist>1
%     while 1
% 
%         % Find all maxima with distance less than minpeakdist
%         firstOfPair=find(diff(locs)<minpeakdist);
%         
%         % If there aren't any, you're done
%         if isempty(firstOfPair), break; end
% 
%         % Get thr heigths of the current peak locations
%         pks=x(locs);
%         
%         % Initialize peakscore
%         peakScore=zeros(size(locs));
%         % Decrement score of too-close peaks
%         secondOfPair=firstOfPair+1;
%         firstPeakLost=pks(firstOfPair)<pks(secondOfPair);
%         
%         % Decrement loosing peaks
%         peakScore(firstOfPair(firstPeakLost))   = -1;
%         peakScore(secondOfPair(~firstPeakLost)) = -1 + peakScore(secondOfPair(~firstPeakLost));
%         
%         % Incremement Winning Peaks
%         peakScore(firstOfPair(~firstPeakLost))  = +1 + peakScore(firstOfPair(~firstPeakLost));
%         peakScore(secondOfPair(firstPeakLost))  = +1 + peakScore(secondOfPair(firstPeakLost));
%         
%         % Remove peaks with a score below zero
%         locs(peakScore<0)=[];
%         
%     end
% end
% 
% if ~allowEdges
%     locs=locs(locs>minpeakdist & locs<length(x)-minpeakdist+1);    
% end
% 
% if nargout>1,
%     pks=x(locs);
% end
% 
% 
% end