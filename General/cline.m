d=dbstack;
if length(d)==1
    disp 'You''re not in debug mode!';
    return;
end

if verLessThan('matlab','7.12')
    editorservices.openAndGoToLine(which(d(2).file),d(2).line);
else
    matlab.desktop.editor.openAndGoToLine(which(d(2).file),d(2).line);
end