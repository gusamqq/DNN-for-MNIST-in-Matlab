function h = seplot( varargin )
% Plot the standard deviation/standard error of a set of timeseries
%
% Example Usage
% h = seplot(time,data);  
% h = seplot(data);  
% h = seplot(...,'se',3);   % The error bars are 2 standard errors from the mean  
% h = seplot(...,'std',2);  % The error bars are 2 standard deviations from the mean  
%
% Time is a length-nSamples vector.
% Data is a size [nSamples nRepetitions nGroups] matrix.


%% Deal with inputs

if length(varargin)==1
    x=varargin{1};
    if isvector(x)
        x=x(:);
    end
    t=(1:size(x,1))';
    varargin={};
elseif isempty(varargin);
    error('You''ve called seplot with no arguments.  What did you expect?');
else
    if isnumeric(varargin{2});
        t=varargin{1};
        x=varargin{2};
        varargin=varargin(3:end);
    else
        x=varargin{1};
        if isvector(x)
            x=x(:);
        end
        t=1:size(x,1);
        varargin=varargin(2:end);
    end
end

% Determine whether to plot Standard error or standard deviation and how
% many
charix=find(cellfun(@ischar,varargin));
[arg loc]=ismember({'se','std'},varargin(charix));
if any(arg)
    assert(~all(arg),'You may only choose "se" or "std"');
    ix=charix(loc(arg));
    type=varargin{ix};
    if length(varargin)==ix || ~isnumeric(varargin{ix+1});
        ndev=1;
        varargin(ix)=[];
    else
        ndev=varargin{ix+1};  
        varargin([ix ix+1])=[];
    end
    
else
    type='se';
    ndev=1; 
end


%% Makr the Plot


mn=squeeze(mean(x,2));
switch type
    case 'se'
        bars=std(x,[],2)/sqrt(size(x,2))*ndev;
    case 'std'
        bars=std(x,[],2)*ndev;
end
bars=squeeze(bars);

hold off
hB1=plot(t(:),mn-bars,varargin{:});
hold on
col=get(hB1,'color');
if ~iscell(col),col={col}; end
hB2=plot(t(:),mn+bars,varargin{:});
arrayfun(@(hh)set(hh,'color',get(hh,'color')/2),[hB1 hB2]);

hM=plot(t(:),mn,'linewidth',2);
arrayfun(@(ix)set(hM(ix),'color',col{ix}),1:length(hM));
hold off

h=[hM hB1 hB2];

% h=errorbar(repmat(t(:),1,size(mn,2)),mn,bars,varargin{:});
% 

end

