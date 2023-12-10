function [R, tr, vo_previous_updated] = visualSOFTt(t, I1_l, I2_l, I1_r, I2_r, P1, P2, vo_params, vo_previous)
%% Initialize parameters
dims = size(I2_l);      % dimensions of image (height x width)
time = zeros(4, 1);      % variable to store time taken by each step

%% Feature points extraction
tic;
% compute new features for current frames
pts2_l = computeFeatures(I2_l, vo_params.feature);
pts2_r = computeFeatures(I2_r, vo_params.feature);
% retrieve extracted features from time t-1
pts1_l = vo_previous.pts1_l;
pts1_r = vo_previous.pts1_r;
time(1) = toc;

%% Circular feature matching
tic;
matches = matchFeaturePoints(I1_l, I1_r, I2_l, I2_r, pts1_l, pts2_l, pts1_r, pts2_r, dims, vo_params.matcher);
time(2) = toc;

%% Feature Selection using bucketing
tic;
bucketed_matches = bucketFeatures(matches, vo_params.bucketing);
time(3) = toc;

%% Rotation (R) and Translation(tr) Estimation by minimizing Reprojection Error
[R, tr] = updateMotionP3P(bucketed_matches, P1, P2, dims);

%% plotting

fprintf('Time taken for feature processing: %6.4f\n', time(1));
fprintf('Time taken for feature matching: %6.4f\n', time(2));
fprintf('Time taken for feature selection: %6.4f\n', time(3));
fprintf('Time taken for motion estimation: %6.4f\n', time(4));

% show features before bucketing
subplot(2, 2, 1);
imshow(I2_l);
hold on;
m_pts2_l = horzcat(matches(:).pt2_l);
plotFeatures(m_pts2_l,  '+r', 2, 0)
% show features after bucketing
m_pts2_l = horzcat(bucketed_matches(:).pt2_l);
plotFeatures(m_pts2_l,  '+g', 2, 0)
title(sprintf('Feature selection using bucketing at frame %d', t))

subplot(2, 2, 3);
showFlowMatches(I1_l, I2_l, bucketed_matches, '-y', 1, '+', 2);
% showStereoMatches(I2_l, I2_r, matches, 1, '-y', 1, '+', 2);
title(sprintf('Flow Matched Features in left camera at frame %d', t));

%% Preparation for next iteration
% allocate features detected in current frames as previous
vo_previous_updated.pts1_l = pts2_l;
vo_previous_updated.pts1_r = pts2_r;

end
