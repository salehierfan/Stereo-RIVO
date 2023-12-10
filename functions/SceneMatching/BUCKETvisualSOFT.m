function [R, tr, vo_previous_updated,sim] = BUCKETvisualSOFT(I2_l,P1, P2, PAR, bucketed_matchess,x,sim)
%% Initialize parameters
dims = size(I2_l);      % dimensions of image (height x width)

%% Feature points extraction
% compute new features for current frames
%  [Index,InNUM,bucketed_matchess]=SDID(I1_l, I2_l, I1_r, I2_r,vo_previous,PAR,x,Index);
% 
% 
% % if 0
% % %     PAR.post
% %  bucketed_matchess=PP(bucketed_matchess,SP,PAR,x,I1_l, I2_l, I1_r, I2_r);
% 
% 
%  bucketed_matchess = NEWbucketFeatures(bucketed_matchess, vo_params.bucketing,x);
% 


% if  size(bucketed_matches1)>20
% bucketed_matches= bucketed_matches1;
% else
   bucketed_matches= bucketed_matchess(1:5:end,:);
%   
% end
% else 
%       bucketed_matches= bucketed_matchess;
% end

location1_l = bucketed_matchess(:,9:10);
location1_r = bucketed_matchess(:,3:4);
location2_l = bucketed_matchess(:,7:8);
distancess=distance(location1_l(:, 1),location1_l(:, 2),location2_l(:,1),location2_l(:,2));
%  subplot(2,1,1),histogram(distancess,300)
% % sim(t,:) =[sum(sum(abs(I1_l(:,:,1)-I2_l(:,:,1))))  sum(sum(abs(I1_l(:,:,2)-I2_l(:,:,2))))  sum(sum(abs(I1_l(:,:,3)-I2_l(:,:,3))))]
%   subplot(2,1,2),showMatchedPoints(I2_l, I1_l,bucketed_matches(1:4:end,7:8),bucketed_matches(1:4:end,9:10))

  %  subplot(3,1,3),showMatchedPoints(I2_l, I1_l,bucketed_matches(1:20:end,7:8),bucketed_matches(1:20:end,7:8))
% size(bucketed_matches,1)
% retrieve extracted features from time t-1
% pts1_l = vo_previous.pts1_l;
% pts1_r = vo_previous.pts1_r;

%% Circular feature matching
% tic;
% matches = matchFeaturePoints(I1_l, I1_r, I2_l, I2_r, pts1_l, pts2_l, pts1_r, pts2_r, dims, vo_params.matcher);
% time(2) = toc;

%% Feature Selection using bucketing
% tic;
% bucketed_matches = bucketFeatures(matches, vo_params.bucketing);
% time(3) = toc;

%% Rotation (R) and Translation(tr) Estimation by minimizing Reprojection Error
[R, tr] = updateMotionP3P(bucketed_matchess, P1, P2, dims,PAR,x);

%% plotting

% fprintf('Time taken for feature processing: %6.4f\n', time(1));
% fprintf('Time taken for feature matching: %6.4f\n', time(2));
% fprintf('Time taken for feature selection: %6.4f\n', time(3));
% fprintf('Time taken for motion estimation: %6.4f\n', time(4));

% show features before bucketing
% subplot(2, 2, 1);
% imshow(I2_l);
% hold on;
% % m_pts2_l = horzcat(matches(:).pt2_l);
% scatter(bucketed_matches(:, 8), bucketed_matches(:, 7),'+r' , 'LineWidth', 2);
% % show features after bucketing
% % m_pts2_l = horzcat(bucketed_matches(:).pt2_l);
% % plotFeatures(m_pts2_l,  '+g', 2, 0)
% % title(sprintf('Feature selection using bucketing at frame %d', t))
% 
% subplot(2, 2, 3);
% showFlowMatches(I1_l, I2_l, bucketed_matches, '-y', 1, '+', 2);
% % showStereoMatches(I2_l, I2_r, matches, 1, '-y', 1, '+', 2);
% title(sprintf('Flow Matched Features in left camera at frame %d', t));

%% Preparation for next iteration
% allocate features detected in current frames as previous
vo_previous_updated.pts1_l = bucketed_matchess(:,7:8);
vo_previous_updated.pts1_r = bucketed_matchess(:,5:6);

end
