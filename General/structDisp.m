function structDisp(s,gap)

if ~exist('gap','var'), gap=0; end;

    ff=fields(s)';
    
    mxln=max(cellfun(@length,ff));

    for f=ff
        fld=f{1};
        
        if isstruct(s.(fld))
            
            structDisp(s.(fld),gap+2);
        else
            fprintf('%s%s%s: %s\n',repmat(' ',1,gap),fld,repmat(' ',1,mxln-length(fld)),des('s.(fld)'));
        end
        
        
    end


end