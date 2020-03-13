function correlationData = getCorrelation(A, B)

if (size(A) ~= size(B))
    display('Error: Inputs must have the same dimensions');
    return;
end

numRows = size(A, 1);
correlationData = zeros(numRows, 1);
truncatePercent = 1;
truncateSize = ceil(max(size(A))*truncatePercent/100);

for i = 1:numRows
    correlationData(i) = corr(A(i,truncateSize:end-truncateSize)',  B(i,truncateSize:end-truncateSize)');
end

end