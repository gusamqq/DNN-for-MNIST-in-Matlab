function peek(varargin)


try
    a=evalin('caller',varargin{1});
catch ME
    fprintf('Error while trying to evaluate "%s"',varargin{1});
    rethrow(ME);
end


if ~isnumeric(a) && ~islogical(a)
    des a
    return
end

if length(varargin)>2
    redims=cellfun(@str2double,varargin(2:end),'uniformoutput',false);
    redims=[redims {[]}];
    a=reshape(a,redims{:});
end

dims=size(a);


hF=figure;
if prod(dims)==max(dims) % It's a line
    if numel(a)<10000000
        plot(squeeze(a));
    else
        iplot(squeeze(a));
    end
elseif numel(dims>1)==2
    imagesc(squeeze(a));    
else
%     mat=squeeze(a);
    
    % Get plane choices
    d=find(dims>1);
    szx=size(a);
    [d1,d2]=meshgrid(d,d);
    ix=d1<d2;
    pairs=[d1(ix) d2(ix)];
    plainChoices=arrayfun(@(i)num2str(pairs(i,:)),1:size(pairs,1),'uniformoutput',false);
    
    
    currentPair=1;
    
    planeIX=ones(size(dims));
    
%     hF=figure;
    hB=[];
    replane;
    
    
    
end
colormap gray;
colorbar;


    function replane
        
        ind=d(~ismember(d,pairs(currentPair,:)));
        subplanes=arrayfun(@(ix,mx)sprintf('~dim%u:@%u',ix,mx),d(ind),szx(ind),'uniformoutput',false);
    
        if ~isempty(hB)
            delete(hB);
        end
        
        [hB val]=UIlibrary.buttons([{plainChoices},subplanes]);
        
        set(hB(1),'callback',@(s,e)changeCurrentPair(val));
        for i=2:length(hB)
            set(hB(i),'callback',@(s,e)setPlane(d(ind(i-1)),val(i)));
            
        end
        
        replot;
    end

    function changeCurrentPair(val)
        currentPair=get(hB(1),'value');
        replane;
    end

    function setPlane(planenumber,ii)
        planeIX(planenumber)=ii;
        replot;
    end

    function replot
        
        
        p=planeIX;
        
        p(pairs(currentPair,:))=-1;
        
        ref=sprintf('%i,',p);
        ref=regexprep(ref,'-1,',':,');
%         ref=regexprep(arrayfun(@(x)sprintf('%u',x),ismember(ix,pairs(currentPair,:))+2),{'2','3'},{'1,',':,'});
%         
        ref=ref(1:end-1);
        submat=eval(sprintf('a(%s);',ref));
        
        
        figure(hF);
        imagesc(squeeze(submat));
        xlabel(sprintf('dim %g',pairs(currentPair,1)));
        ylabel(sprintf('dim %g',pairs(currentPair,2)));
        title([des(a) '(' ref ')']);
        colorbar;
    end

end