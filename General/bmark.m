function bmark(tag)

% d=dbstack;

% if length(d)==1
%     disp 'No bookmark to be made.  You''re in the base workspace.  You need to be in debug mode to use bookmarks.';
% else
    
    if ~exist('tag','var'), tag=''; end
%     
%     d=d(2);

    if ~verLessThan('matlab','7.12')
        filename=matlab.desktop.editor.getActive().Filename;
        line=matlab.desktop.editor.getActive().Selection(1);
        [~,shortname]=fileparts(filename);
        
        fprintf('<a href="matlab:edit %s;matlab.desktop.editor.findOpenDocument(which(''%s'')).goToLine(%u);">%s:%s at %u</a>\n',...
            filename,filename,line,tag,shortname,line)
    else
        filename=editorservices.getActive().Filename;
        line=editorservices.getActive().Selection(1);
        
        [~,shortname]=fileparts(filename);
        
        fprintf('<a href="matlab:edit %s;editorservices.openAndGoToLine(''%s'',%u);">%s:%s at %u</a>\n',...
            filename,filename,line,tag,shortname,line);
    end
    
    
% end

end