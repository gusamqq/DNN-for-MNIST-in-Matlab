function [h spacing hZeros]=mplot(varargin)
% Like plot, except gives the plotted signals vertical offsets.  Nice if
% you have a whole lot of signals and don't really care about their
% DC-values.
%
%



%% Setup numeric inputs
yD=varargin{1};
if isvector(yD), yD=yD(:); end

if length(varargin)>1 && isnumeric(varargin{2}) % x-data included   
   xD=yD;
   yD=varargin{2};
   if isvector(yD), yD=yD(:); end
      
   varargin=varargin(3:end);
else                      % x-data not included
   xD=(1:size(yD,1))';
   varargin=varargin(2:end);
end


ix=find(strcmpi(varargin,'spacing'),1);
if ~isempty(ix)
    spacing=varargin{ix+1};
    varargin(ix:ix+1)=[];
    if isempty(spacing), ix=[]; end
    if numel(spacing)>1 && length(spacing)~=size(yD,2)
        error ('Your spacing vector length (%g) doesn''t match your yData count (%g)',length(spacing),size(yD,2));
    end
end
if isempty(ix)
    if isempty (yD), q=[0 1];
    else q=quickclip(yD(:),.02);
    end
    spacing=max(diff(q),1e-14)*1.3;
end


ix=find(strcmpi(varargin,'showzero'),1);
if ~isempty(ix), 
    basething=varargin{ix+1};
    varargin(ix:ix+1)=[];
else
    basething=false;
end

%% Plotting

nD=max(size(xD,2),size(yD,2));
nS=max(size(xD,1),size(yD,1));

if numel(spacing)>1
    spacevec=spacing;
else
    spacevec=linspace(0,(nD-1)*spacing,nD);
end

if ~isempty(yD)
    yD=bsxfun(@minus,yD,spacevec);
end



if basething
    hZeros=plot(xD([1 end]),repmat(-spacevec,[2 1]),'linestyle','--','color',[.5 .5 .5]); 
%     if numel(spacing)>1
%         
%     else
%         hZeros=plot([xD(1) max(xD(end,:))],repmat(-linspace(0,nD*spacing,nD),[2 1]),'linestyle','--','color',[.5 .5 .5]); 
%     end
end
hh=ishold;
if ~hh
    hold on;
end

hP=plot(xD,yD,varargin{:});
if nargout>0, h=hP; end

if ~hh
   hold off; 
end




end