function figup

oldShow=get(0,'ShowHiddenHandles');
set(0,'ShowHiddenHandles','on');

hF=get(0,'children');

for i=1:length(hF)
    figure(hF)
end

set(0,'ShowHiddenHandles',oldShow);


end
