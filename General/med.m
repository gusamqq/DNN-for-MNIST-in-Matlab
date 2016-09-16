function med
% Get all m-files open in the editor, display links to go to/close them.
% 
%
%


if ~verLessThan('matlab','7.12')

    f=matlab.desktop.editor.getAll;
else
    f=editorservices.getAll;
end
    
    
filenames=cellfun(@(s)s(find(s==filesep,1,'last')+1:end-2),{f.Filename},'uniformoutput',false);
[filenames,ix]=sort(filenames);
f=f(ix);

lens=cellfun(@length,filenames);
maxlen=max(lens);

for i=1:length(filenames)
    if ~verLessThan('matlab','7.12')
        fprintf('<a href="matlab:edit ''%s''">%s</a>%s<a href="matlab:matlab.desktop.editor.findOpenDocument(''%s'').close"> X </a>\n',f(i).Filename,filenames{i},repmat('.',1,maxlen+8-lens(i)),filenames{i});
    else
        fprintf('<a href="matlab:edit ''%s''">%s</a>%s<a href="matlab:editorservices.open(which(''%s'')).close"> X </a>\n',f(i).Filename,filenames{i},repmat('.',1,maxlen+8-lens(i)),filenames{i});
    end
end