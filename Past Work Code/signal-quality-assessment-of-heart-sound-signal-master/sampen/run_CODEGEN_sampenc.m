%This will only work for 4-state CRFs


%% The format is:
% codegen "name of function" -args { coder.typeof(0, [rows columns], [can the row variable change size (0/1)?  can the column variable change size (0/1)?])}
codegen sampenc -args {coder.typeof(0, [100000 1], [1 0])  coder.typeof(0, [1 1], [0 0])   coder.typeof(0, [1 1], [0 0])}
