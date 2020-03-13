function [counts,U,idxMatch] = cellhist(A)
% A: cell array of strings
% Forms a histogram of the strings in A.

U = unique(A);
idxMatch = {};
counts = zeros(1, length(U));
for i=1:length(U)
    idx = strcmp(U{i}, A);
    counts(i) = length(find(idx == 1));
    idxMatch{i} = idx;
end;