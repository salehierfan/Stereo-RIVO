function [R, tr] = updateMotionP3P(matches, P1, P2, dims, PAR,z)
%UPDATEMOTION Given matched points in the left and right frames of the
% stereo system along with the projection matrices for each camera,
% estimate the incremental camera motion using P3P algorithm with RANSAC
%
% INPUT:
%   - matches(1, N): matched feature points locations in left camera frame
%   - P1(3, 4): Projection matrix for left camera
%   - P2(3, 4): Projection matrices for right camera respectively
%   - dims(1, 2): dimensions of image (height x width)
%
% OUTPUT:
%   - points3D(3, N): 3-D locations of points in world coordinate system

% m_pts1_l = horzcat(matches(:).pt1_l);  
location1_l = matches(:,9:10);
% m_pts1_r = horzcat(matches(:).pt1_r);  
location1_r = matches(:,3:4);
% m_pts2_l = horzcat(matches(:).pt2_l);  
location2_l = matches(:,7:8);

% invert x-y corrdinates for image processing tooblox
im_pts1_l = [location1_l(:, 1), location1_l(:, 2)];
im_pts1_r = [location1_r(:, 1), location1_r(:, 2)];
im_pts2_l = [location2_l(:, 1), location2_l(:, 2)];

% distancess=distance(location1_l(:, 1),location1_l(:, 2),im_pts2_l(:,1),im_pts2_l(:,2));
%  histogram(distancess,100)
        
% 3D Point Cloud generation at time t-1 using triangulation
points3D_1 = triangulate(im_pts1_l, im_pts1_r, P1', P2')';

% invert x-y corrdinates for image processing tooblox

% motion estimation by minimizing reprojection error and RANSAC
cam1 = cameraIntrinsics([P1(1, 1), P1(2,2)], [P1(1, 3), P1(2, 3)], dims(:,1:2));

%  [R, tr] = estimateWorldCameraPose(im_pts2_l, points3D_1', cam1, 'MaxReprojectionError',PAR.maxRepError(1,z),...
%      'MaxNumTrials',PAR.trialMAXnum(1,z) ,'Confidence',PAR.InlierConf(1,z));
[R, tr] = estimateWorldCameraPose(im_pts2_l, points3D_1', cam1, 'MaxReprojectionError',PAR.maxRepError(1,z));

end
