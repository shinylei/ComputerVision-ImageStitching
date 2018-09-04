function descriptor = getDescriptor(image, rows, cols, neighborSize) 
    filter = zeros(2*neighborSize+1);
    filter(neighborSize + 1, neighborSize + 1) = 1;
    filtered = imfilter(image, filter, 'replicate', 'full');
    n = length(rows);
    descriptor = zeros(n, (2*neighborSize+1)^2);
    for i = 1 : n
        row = rows(i);
        col = cols(i);
        descriptor(i,:) = reshape(filtered(row: row+2*neighborSize, col: col+2*neighborSize),1, (2*neighborSize+1)^2); 
    end
    %normalization
    ave = sum(descriptor, 2)/(neighborSize*2+1);
    descriptor = descriptor - ave;
    norm = sqrt(sum(descriptor.^2, 2));
    descriptor = descriptor ./ norm;
end