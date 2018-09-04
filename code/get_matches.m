function [left_points, right_points, matchedNum] = get_matches(leftIm_rgb, rightIm_rgb)
%Input: Left RGB image, right RGB image
%Output: matched feature points and matched number

    % STEP1 - convert to grayscale and double
    leftIm = (im2double(rgb2gray(leftIm_rgb)));
    rightIm = (im2double(rgb2gray(rightIm_rgb)));

    %STEP2 - detect features using harris.m
    %%%%%%%%%%%%
    sigma = 2; thresh = 0.05; radius = 2;  disp = 0;
    [~, r_left, c_left] = harris(leftIm, sigma, thresh, radius, disp);
    [~, r_right, c_right] = harris(rightIm, sigma, thresh, radius, disp);

    %STEP3 - extract local neighbor to form descriptors
    %%%%%%%%%%%
    neighborSize = 10;
    descriptor_left = getDescriptor(leftIm, r_left, c_left, neighborSize);
    descriptor_right = getDescriptor(rightIm, r_right, c_right, neighborSize);

    %STEP4 - compute distances
    D = dist2(descriptor_left, descriptor_right);
         
    %STEP5 - select putative matches
    thres = 0.00005;
    %thres = 6;%%%%
    [leftIndex, rightIndex] = find (D < thres);
    matchedNum = length(leftIndex);
    matchedNum;
    left_points = [c_left(leftIndex), r_left(leftIndex)]; %%this is matched feature points
    right_points = [c_right(rightIndex), r_right(rightIndex)];
end