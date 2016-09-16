function [h hF]=cellwin(C,varargin)
% Window to show cell array data.
%
% Possible Aruments:
% name: title of cell window
%


i=1;
while i<length(varargin)
   switch varargin{i}
       case 'name'
           name=varargin{i+1};
           varargin(i:i+1)=[];
       case 'frame'
           hF=varargin{i+1};
           varargin(i:i+1)=[];
   end
   i=i+2;
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


hf=uimenu(hF,'Label','Table');
uimenu(hf,'Label','Export',        'callback',@(e,s)export);

vecix=cellfun(@isvector,C);
C(vecix)=cellfun(@(x)num2str(x(:)'),C(vecix),'uniformoutput',false);

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

h=uitable('data',C,'units','normalized','position',[0 0 1 1],varargin{:});
% h=uitable('data',C);


    function export
        
        Ce=C;
        
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