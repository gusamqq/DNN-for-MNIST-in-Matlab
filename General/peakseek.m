% function [locs pks]=peakseek(x,minpeakdist,minpeakh,allowEdges)
% % [locs pks]=peakseek(x,minpeakdist,minpeakh,allowEdges)
% %
% % Alternative to the findpeaks function.  It returns different (and for
% % most application better) results than findpeaks, and runs in something
% % like NlogN time.
% %
% % Example Use:
% % x=cos(linspace(0,50,1000))+randn(1,1000)*.2;
% % [locs heights]=peakseek(x,30);    % Find all peaks that are the highest within 20 samples 
% % clf; plot(x); hold all; plot(locs,heights,'*');
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
%         
%         % Determine winners and losers
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





% Old, version.  Had some problems with "false" peaks
function [locs pks]=peakseek(x,minpeakdist,minpeakh)
% Alternative to the findpeaks function.  This thing runs much much faster.
% It really leaves findpeaks in the dust.  It also can handle ties between
% peaks.  Findpeaks just erases both in a tie.  
%
% x is a vector input (generally a timecourse)
% minpeakdist is the minimum desired distance between peaks (optional, defaults to 1)
% minpeakh is the minimum height of a peak (optional)
%
% (c) 2010
% Peter O'Connor
% peter<dot>ed<dot>oconnor .AT. gmail<dot>com

if size(x,2)==1, x=x'; end

% Find all maxima and ties
locs=find(x(2:end-1)>=x(1:end-2) & x(2:end-1)>=x(3:end))+1;

if nargin<2, minpeakdist=1; end % If no minpeakdist specified, default to 1.

if nargin>2 % If there's a minpeakheight
    locs(x(locs)<=minpeakh)=[];
end

if minpeakdist>1
    while 1

        del=diff(locs)<minpeakdist;

        if ~any(del), break; end

        pks=x(locs);

        [garb mins]=min([pks(del) ; pks([false del])]); %#ok<ASGLU>

        deln=find(del);

        deln=[deln(mins==1) deln(mins==2)+1];

        locs(deln)=[];

    end
end

if nargout>1,
    pks=x(locs);
end


end