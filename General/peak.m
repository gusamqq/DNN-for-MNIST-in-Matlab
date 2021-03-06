function peak(varargin)


try
    a=evalin('caller',varargin{1});
catch ME
    fprintf('Error while trying to evaluate "%s"',arg);
    rethrow(ME);
end


if ~isnumeric(a)
    des a
    return
end

dims=cellfun(@str2double,varargin(2:end));
if prod(dims)==max(dims)
    if numel(a)<10000000
        plot(squeeze(a));
    else
        iplot(squeeze(a));
    end
end


figure;
