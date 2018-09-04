function stitchedIm = stitch_pair(leftIm_rgb, rightIm_rgb, flag) 

    %get matched feature points
    [left_points, right_points, matchedNum] = get_matches(leftIm_rgb, rightIm_rgb);
    matchedNum
    
    %run RANSAC to get inlier points from matched feature points we get
    %above
    [H, max_inlier_num, inliers_left, inliers_right] = RANSAC(left_points, right_points, matchedNum);
    
    max_inlier_num
    if flag == 1
        % calculate average residual    
        transformed = H * [inliers_left' ; ones(1, max_inlier_num)];
        transformed = transformed(1:2, :) ./ transformed(3, :);
        diff = sum((transformed - inliers_right').^2, 1);
        residual = sum(diff) / max_inlier_num;
        residual
        
        %show inliers selected
        w = size(leftIm_rgb,2);
        figure; imshow([leftIm_rgb rightIm_rgb]); hold on;    
        for i=1 : max_inlier_num
            plot([inliers_left(i,1) inliers_right(i,1)+w], [inliers_left(i,2) inliers_right(i,2)],'-ys');  
        end
    end
    
    %stitch two images
    
    tform = maketform('projective', H');
    [~,xdata,ydata]=imtransform(leftIm_rgb,tform, 'nearest');
    xpos=[min(1,xdata(1)) max(size(rightIm_rgb,2), xdata(2))];
    ypos=[min(1,ydata(1)) max(size(rightIm_rgb,1), ydata(2))];

    left_transformed=imtransform(leftIm_rgb,tform,'XData',xpos,'YData',ypos);
    right_transformed=imtransform(rightIm_rgb,maketform('affine',eye(3)),'XData',xpos,'YData',ypos);
   
    stitchedIm = left_transformed/2 + right_transformed/2;
    
    for i=1:size(right_transformed,1)
        for j=1:size(right_transformed,2)
            if(~isequal(left_transformed(i,j,:),zeros(1,1,3)) && ~isequal(right_transformed(i,j,:),zeros(1,1,3)))
                stitchedIm(i,j,:) = stitchedIm(i,j,:)/2;
            end 
        end 
    end
    stitchedIm = stitchedIm * 2;
end
