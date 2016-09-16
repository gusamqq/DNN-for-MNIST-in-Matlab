classdef ProgressPrinter < handle
    
    properties
        
        final;
        
        increment=0.01;
        next;
        
        first=true;
    end
    
    
    methods
        
        function A=ProgressPrinter(text,final)
            
            fprintf('%s...',text);
            
            A.next=A.increment*final;
            A.final=final;
        end
        
        function update(A,val)
            
            
            if val>A.next
                
                if ~A.first
                fprintf('%c%c%c%c%c%c',8,8,8,8,8,8);
                else
                    A.first=false;
                end

                fprintf('% 5.3g%%',val/A.final)
                A.next=A.next+A.increment*A.final;
            end
                        
        end
        
        function done(A)
            fprintf('%c%c%c%c%c%c',8,8,8,8,8,8);
            disp '  Done';
        end
        
    end
    
    
end