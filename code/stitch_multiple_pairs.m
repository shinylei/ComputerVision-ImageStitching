function stitchedIm = stitch_multiple_pairs(images)
    n = length(images);
    stitchedIm = images{1};
    
    vis = zeros(n, 1); %this vector is used to mark whether an image has been used 
    vis(1) = 1;
    
    for count = 2 : n %% n images stitch n-1 times
       
       inlier_num = zeros(n, 1);
       for i = 1 : n
          if vis(i) == 0
              [left_points, right_points, matchedNum] = get_matches(stitchedIm, images{i});
              [~, max_inlier_num, ~, ~] = RANSAC(left_points, right_points, matchedNum);
              inlier_num(i) = max_inlier_num;
          end
       end
       
       [~, index] = max(inlier_num); %pick image index
       vis(index) = 1; %mark as used
       %stitched = stitch_pair(stitched, images{index});
       imshow(stitchedIm)
       stitchedIm = stitch_pair(images{index}, stitchedIm, 2);
    end
end