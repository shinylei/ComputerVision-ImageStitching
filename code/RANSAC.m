function [H, max_inlier_num, inliers_left, inliers_right] = RANSAC(left_points, right_points, matchedNum)
    %run RANSAC
    iterNum = 40000;
    inlierThres = 10;%%%%%%%%%
    max_inlier_num = 0;
    inliers = [];
    
    for i = 1 : iterNum
        sample = randperm(matchedNum,4);
      
        %construct matrix A
        A = zeros(8,9);
        for j = 1 : 4
            x = left_points(sample(j), 1);
            y = left_points(sample(j), 2);
            x1 = right_points(sample(j),1);
            y1 = right_points(sample(j), 2);
            A(2*j-1 ,:) = [0, 0, 0, x, y, 1, -x * y1, -y * y1, -y1];
            A(2*j,:) = [x, y, 1, 0, 0, 0, -x*x1, -y* x1, -x1];
        end
    
        %compute transformation H 
        [~, ~, V] = svd(A);
        h = reshape(V(:,end), [3,3])';
    
        transformed = h * [left_points' ; ones(1, matchedNum)];
        transformed = transformed(1:2, :) ./ transformed(3, :);
        diff = sum((transformed - right_points').^2, 1);
        inliers_temp = find(diff < inlierThres);
    
        if length(inliers_temp) > max_inlier_num
            max_inlier_num = length(inliers_temp);
            inliers = inliers_temp;
            %H = h;
        end
    end
  
    %compute transformation using inliers get above
    A1 = zeros(max_inlier_num*2, 9);
    inliers_left = left_points(inliers, :);
    inliers_right = right_points(inliers, :);
    for i = 1 : max_inlier_num
        x = inliers_left(i, 1);
        y = inliers_left(i, 2);
        x1 = inliers_right(i,1);
        y1 = inliers_right(i, 2);
        A1(2*i-1 ,:) = [0, 0, 0, x, y, 1, -x * y1, -y * y1, -y1];
        A1(2*i,:) = [x, y, 1, 0, 0, 0, -x*x1, -y* x1, -x1];
    end
    [~, ~, V] = svd(A1);
    H = reshape(V(:,end), [3,3])';
  
end