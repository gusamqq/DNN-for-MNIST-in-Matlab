function [h hF]=theTableMaker(C,varargin)
% Window to show cell array data.
%
% Possible Aruments:
% name: title of cell window
%

%% Deal with inputs

if isnumeric(C)
    C=num2cell(C);
end

labels=cell(1,ndims(C));
dimLabels=cell(1,ndims(C));


i=1;
while i<length(varargin)
   switch varargin{i}
       case 'name'
           name=varargin{i+1};
           varargin(i:i+1)=[];
       case 'frame'
           hF=varargin{i+1};
           varargin(i:i+1)=[];
       case 'labels'
           labels=varargin{i+1};
           varargin(i:i+1)=[];           
       case 'dimLabels'
           dimLabels=varargin{i+1};
           for k=1:length(dimLabels)
               assert(isempty(dimLabels{k})||length(dimLabels{k})==size(C,k),'The %g-th dimension has size %g but %g labels',k,size(C,k),length(dimLabels{k}));
           end    
           varargin(i:i+1)=[];
       otherwise
           i=i+2;
   end
   
end

for i=1:length(labels)
    if isempty(labels{i})
        labels{i}=sprintf('dim%g',i);
    end
end

for i=1:length(dimLabels)
    if isempty(dimLabels{i})
        dimLabels{i}=strcat(labels{i},'-', arrayfun(@num2str,1:size(C,i),'uniformoutput',false));
    end
end

if ~exist('hF','var')
    hF=figure(ceil(rand*10000));
end

x=strcmpi(varargin(1:2:end),'name');
if exist('name','var')
    ix=find(x,1,'last')*2;
    switch get(hF,'type')
        case 'uipanel'
            set(hF,'title',name);
        case 'figure'
            set(hF,'name',name);
    end
    varargin(ix-1:ix)=[];
end


%% Initialize index counters
    dims=size(C);

    d=find(dims>1);
%     szx=size(a);
    [d1,d2]=meshgrid(d,d);
    ix=d1<d2;
    pairs=[d1(ix) d2(ix)];
%     plainChoices=arrayfun(@(i)num2str(pairs(i,:)),1:size(pairs,1),'uniformoutput',false);
    
    plainChoices=strcat(labels(pairs(:,1)),'-',labels(pairs(:,2)));
    
    currentPair=1;
    
    planeIX=ones(size(dims));
    
%     hF=figure;
    hB=[];    


%%



hf=uimenu(hF,'Label','Table');
uimenu(hf,'Label','Export',        'callback',@(e,s)export);
ht=uicontrol('style','text','units','normalized','position',[0,.95,1,.05],'fontsize',12);

% h=uitable('data',C);

replane;

    function replot
        
        % Get the appropriat submatrix
        p=planeIX;
        p(pairs(currentPair,:))=-1;
        ref=sprintf('%i,',p);
        ref=regexprep(ref,'-1,',':,');  
        ref=ref(1:end-1);
        submat=eval(sprintf('C(%s);',ref));
        
        vecix=cellfun(@isvector,submat);
        submat(vecix)=cellfun(@(x)num2str(x(:)'),submat(vecix),'uniformoutput',false);


        if strcmp(get(hF,'type'),'uipanel') % Place it relative to panel loc
            ix=find(strcmp(varargin,'position'));
            pp=get(hF,'position');
            if ix
                position=varargin{i+1}*pp([3 4 3 4])+[pp([1 2]).*pp([3 4]) 0 0];
                varargin{ix+1}=position;
            else
                varargin=[varargin 'position' pp];
            end
        end

        submat=squeeze(submat);
        
        args=varargin;
        rowDim=pairs(currentPair,1);
%         if ~isempty(labels{rowDim})
%             if ischar(labels{rowDim})
%                 rowlab=strcat(labels{rowDim},'-', arrayfun(@num2str,1:size(submat,1),'uniformoutput',false));
%             else
%                 rowlab=labels{rowDim};
%             end            
%             
%         end
        
        colDim=pairs(currentPair,2);
%         if ~isempty(labels{colDim})
%             if ischar(labels{colDim})
%                 collab=strcat(labels{colDim},'-', arrayfun(@num2str,1:size(submat,1),'uniformoutput',false));
%             else
%                 collab=labels{colDim};
%             end      
%             
%             args=[args,{'ColumnName',collab}];
%         end
        args=[args,{'RowName',dimLabels{rowDim}}];
        args=[args,{'ColumnName',dimLabels{colDim}}];
        
        h=uitable('data',submat,'units','normalized','position',[0 .1 1 .85],args{:});
        
        noncurrent=find(p~=-1);
        arr=arrayfun(@(lab,dim)[labels{lab} ':' dimLabels{lab}{dim},'  '],noncurrent,planeIX(noncurrent),'uniformoutput',false);
        set(ht,'string',cat(2,arr{:}));
        
        set(hF,'toolbar','none');
        
    end





    function replane
        
        ind=d(~ismember(d,pairs(currentPair,:)));
        subplanes=arrayfun(@(ix,mx)sprintf('~%s:@%u',labels{ix},mx),d(ind),dims(ind),'uniformoutput',false);
    
        if ~isempty(hB)
            delete(hB);
        end
        
        [hB val]=UIlibrary.buttons([{plainChoices},subplanes]);
        
        set(hB(1),'callback',@(s,e)changeCurrentPair);
        for j=2:length(hB)
            set(hB(j),'callback',@(s,e)setPlane(d(ind(j-1)),val(j)));
            
        end
        
        replot;
    end


    function changeCurrentPair
        currentPair=get(hB(1),'value');
        replane;
    end

    function setPlane(planenumber,ii)
        planeIX(planenumber)=ii;
        replot;
    end


    function export
        
        Ce=C;
        
        res=questdlg('How do you write your numbers?','Format','Like a German','Like Everybody else','I don''t','Like Everybody else');
        switch res
            case 'German'
                Ce=regexprep(Ce,'\.',',');
            case 'I don''t'
                return;
        end
                
        ii=find(strcmpi(varargin(1:2:end),'RowName'),1);
        if ii
            Ce=[reshape(varargin{ii*2},[],1) Ce];
        end
        
        iii=find(strcmpi(varargin(1:2:end),'ColumnName'),1);
        if iii
            if ii, fill={[]}; else fill={}; end
            Ce=[fill reshape(varargin{iii*2},1,[]); Ce];
        end
        
         
        [f p]=uiputfile('.xls');
        if f==0,return; end    
        
        filename=[p f];

        
        
        fprintf('Writing to Excel...');

        xlswrite(filename,Ce);

        fprintf('Done. \n  file: <a href="matlab: winopen(''%s'')">%s</a>\n',filename,filename);

        
    end

end









% 
% 
% 
% 
% 
% function [h hF]=cellwin(C,varargin)
% % Window to show cell array data.
% 
% hF=figure(ceil(rand*10000));
% 
% if islogical(C) || isnumeric(C)
%     C=num2cell(C);
% end
% 
% 
% x=strcmpi(varargin(1:2:end),'name');
% if any(x)
%     ix=find(x,1,'last')*2;
%     set(hF,'name',varargin{ix});
%     varargin(ix-1:ix)=[];
% end
% 
% 
% 
% ix=cellfun(@(x)numel(x)>1,C(:));
% C(ix)=cellfun(@(x)['[',num2str(x),']'],C(ix),'uniformoutput',false);
% 
% h=uitable('data',C,'units','normalized','position',[0 0 1 1],varargin{:});
% % h=uitable('data',C);
% 
% end