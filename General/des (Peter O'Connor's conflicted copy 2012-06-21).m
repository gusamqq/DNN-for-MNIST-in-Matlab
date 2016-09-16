function str=des(arg)
% Describe the input.
%
% Call this function with the name of the input, and it will describe it.
% Useful for getting the gist of what's in an array without the ridiculous
% printout of elements.
%
% eg:
% a=randn(1000,500);
% des a;

if ~ischar(arg), arg=inputname(1); end
% 
% assert(evalin('caller',['exist(''' arg ''',''var'')'])>0,'"%s" is not a variable',arg); 




try
    a=evalin('caller',arg);
catch ME
    fprintf('Error while trying to evaluate "%s"',arg);
    rethrow(ME);
end


dims=size(a);
if isequal(dims,[1 1])
    sz='scalar';
else
    sz=regexprep(num2str(dims),' *','x');
end

if isnumeric(a)
        
    if numel(a)<10
       str=a;
       return;
    end
    
    
    perfectLimit=1000000;
    if numel(a)<perfectLimit % Computers are FAST
        rng=full([min(a(:)) max(a(:))]);
        addit=sprintf('in rng [%.3g %.3g], mn:%.3g, sd:%.3g',rng(1),rng(2),mean(a(:)),std(double(a(:))));
    else
        b=a(ceil(numel(a)*rand(1,perfectLimit))); % Random subsample - it's faster
        rng=full([min(b(:)) max(b(:))]);
        addit=sprintf('in ~rng [%.3g %.3g], mn:%.3g, sd:%.3g',rng(1),rng(2),mean(b(:)),std(double(b(:))));
    end    
    
elseif islogical(a)
    frac=nnz(a(:))/numel(a);
    addit=sprintf('with %g%% of elements true',frac*100);
elseif ischar(a)
    if length(a)<50
        addit=a;
    end

elseif iscell(a)
    
    if length(a)<10
        fprintf('A cell array containing:\n')
%         disp(a);
        for i=1:length(a)
            fprintf('  %g: ',i);
            des a{i};            
        end
        
        return;
    end
    
    if iscellstr(a)
        addit='array of strings';
    else
        types=unique(cellfun(@class,a,'uniformoutput',false));
        types=strcat(types,', ');
        types=strcat(types{:});
        addit=sprintf('array of %s',types(1:end-1));
    end
elseif isstruct(a)
    
    if numel(a)==1
        fprintf('A struct with fields:\n');
        disp(a);
    else
        fprintf('A ');
        disp(a);
    end
    return;
else
    addit=8;
end

if isobject(a)
    st=sprintf('A %s <a href="matlab:sig %s">%s</a> %s.\n',sz,class(a),class(a),addit);
else
    st=sprintf('A %s %s %s.\n',sz,class(a),addit);
end

if nargout>0
    str=st;
else
    disp(st);
end
    