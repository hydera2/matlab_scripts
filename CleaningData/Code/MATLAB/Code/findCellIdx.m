function foundIdx = findCellIdx(A,B)
% A: cell array of strings
% Forms a histogram of the strings in A.

foundIdx = [];
for i=1:length(B)
    idx = strcmp(B{i}, A);
	if (~isempty(find(idx == 1)))
		foundIdx(i) = find(idx == 1);
	end
end

end