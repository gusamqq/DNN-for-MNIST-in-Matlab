function arg=argk(func,k)
% Return the kth argument

assert(isa(func,'function_handle'),'func must be a function handle');

cc=cell(1,k);

[cc{:}]=func();

arg=cc{k};

end