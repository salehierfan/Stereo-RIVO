
% % % % % % % % % %   Stereo-RIVO: Stereo-Robust Indirect Visual Odometry   % % % % % % % % % % 

clc; clear; close all
warning off

%% Execute the configuration file to read parameters for data paths
addpath('config');   % % config: is file contain dataset, poses, hyper-parameters, and calibration parameters pathes
configFile; 
hyperPAR
addpath(genpath('functions'));   % % functions: is file contain sub-mudules (PhA, Bucketing, utils) 

%% Read directories containing images
img_files1 = dir(strcat(data_params.path1,'*.png'));
img_files2 = dir(strcat(data_params.path2,'*.png'));
num_of_images = length(img_files1);

%% Read camera parameters
[P1, P2] = createCamProjectionMatrices(cam_params);

%% Read ground truth file if flag is true
if data_params.show_gt_flag
  ground_truth = load(data_params.gt_file);  gt_x_max = max(ground_truth(:, end - 8));
  gt_x_min = min(ground_truth(:, end - 8));  gt_z_max = max(ground_truth(:, end));
  gt_z_min = min(ground_truth(:, end));
end

%% Initialize variables for odometry
pos = [0;0;0];
Rpos = eye(3);
showRoadMap=0;

%% Start Algorithm
% sampled pixels

CG =load('CGtsu.mat'); 
CG1=CG(1:round(PAR.pixelsamRate):end,:);

% define initial index for inlier detection
Index=ones(size(CG1,1),1);

start = 0;
if showRoadMap
    figure
end
FRAMEnumber=0;

sim= [];
for t = 1: num_of_images-1
   
    %% Read images for time instant t
     I2_l = (imread([img_files1(t+1).folder, '/', img_files1(t).name]));
     I2_r = (imread([img_files2(t+1).folder, '/', img_files2(t).name]));

%%      KFD module
     if t>3
         sim(t,:)=[mean(mean(abs(I1_l(:,:,1)-I2_l(:,:,1)))) mean(mean(abs(I1_l(:,:,2)-I2_l(:,:,2)))) ...
             mean(mean(abs(I1_l(:,:,3)-I2_l(:,:,3))))];
         simm(t,1)=[mean(mean(DispPostProcKFD(abs(I1_l(:,:,1)-I2_l(:,:,1)),PAR,xx)))];
         if  simm(t,1)> PAR.RacklessKFD(1,xx)
             continue
         end
     end

   %% Bootstraping for initialization
   if (start == 0)
       [vo_previouss,IndexResult]= pointsTracker(CG1,I2_l,I2_r,PAR,xx,Index);
       vo_previous.pts1_l =vo_previouss(:,1:2) ;    vo_previous.pts1_r =vo_previouss(:,3:4);
       start = 1;        
       I1_l = I2_l;        I1_r = I2_r;
       continue;
   end
   %    showMatchedFeaturesNew(I1_l, I2_l, vo_previouss(:,1:2), vo_previouss(:,3:4))
   
   %% Scene matching between two Key-frame          
   
   [Index,InNUM(t),bucketed_matches]=SDID(I1_l, I2_l, I1_r, I2_r,vo_previouss,PAR,xx,IndexResult);
   
%    showMatchedFeaturesNew(I1_l, I2_l, bucketed_matches(:,9:10), bucketed_matches(:,7:8))

   distt = distance(bucketed_matches(:,9),bucketed_matches(:,10),bucketed_matches(:,3),...
       bucketed_matches(:,4));
   
   bucketed_matchess = bucketed_matches(distt > PAR.nearF(xx),:);
   bucketed_matchess = bucketed_matches;

   if PAR.Bucketing
       bucketed_matchess =NEWbucketFeatures(bucketed_matches, vo_params.bucketing,1);
   end
   
   figure,showMatchedFeaturesNew(I1_l, I2_l, bucketed_matchess(:,9:10), bucketed_matchess(:,7:8))

   if size(bucketed_matches,1)>=1
       if size(bucketed_matches,1)>=400 && 1
           [R,tr,vo_previous,sim] =BUCKETvisualSOFT(I2_l,P1, P2, PAR, bucketed_matchess,xx,sim);
           else if size(bucketed_matches,1)<399 && size(bucketed_matches,1)>=200 && 1
                   CG11=CG(1:round(0.5*PAR.pixelsamRate(1,xx)):end,:);
                   Index=ones(size(CG11,1),1);
                   [vo_previouss,IndexResult]= pointsTracker(CG11,I2_l,I2_r,PAR,xx,Index);
                   
                   vo_previous.pts1_l = vo_previouss(:,1:2);    vo_previous.pts1_r =vo_previouss(:,3:4);
                   [Index,InNUM(t),bucketed_matches]=SDID(I1_l, I2_l, I1_r, I2_r,vo_previouss,PAR,xx,IndexResult);
                   
                   distt = distance(bucketed_matches(:,9),bucketed_matches(:,10),bucketed_matches(:,3),bucketed_matches(:,4));
                   bucketed_matches = bucketed_matches(distt > PAR.nearF(xx),:);
                   bucketed_matchess = bucketed_matches;
                   if PAR.Bucketing
                       bucketed_matchess =NEWbucketFeatures(bucketed_matches, vo_params.bucketing,1);
                   end
                   NEWbucketFeatures(bucketed_matches, vo_params.bucketing,1);
                   [R,tr,vo_previous,sim] =BUCKETvisualSOFT(I2_l,P1, P2, PAR, bucketed_matchess,xx,sim); 
           else  
               CG12=CG(1: ceil(0.2*PAR.pixelsamRate(1,xx)):end,:);
               Index=ones(size(CG12,1),1);
               
               [vo_previouss,IndexResult]= pointsTracker(CG12,I2_l,I2_r,PAR,xx,Index);
               vo_previous.pts1_l = vo_previouss(:,1:2);    vo_previous.pts1_r =vo_previouss(:,3:4);
               
               [Index,InNUM(t),bucketed_matches]=SDID(I1_l, I2_l, I1_r, I2_r,vo_previouss,PAR,xx,IndexResult);
               
               distt = distance(bucketed_matches(:,9),bucketed_matches(:,10),bucketed_matches(:,3),...
                   bucketed_matches(:,4));
               bucketed_matchess = bucketed_matches(distt > PAR.nearF(xx),:);
               
               bucketed_matchess = bucketed_matches;
               if PAR.Bucketing
                   bucketed_matchess =NEWbucketFeatures(bucketed_matches, vo_params.bucketing,1);
               end
               
               NEWbucketFeatures(bucketed_matches, vo_params.bucketing,1);
               
               [R,tr,vo_previous,sim] =BUCKETvisualSOFT(I2_l,P1, P2, PAR, bucketed_matchess,xx,sim);
           end
           
       end
   else
       continue;
   end

   %% Estimated pose relative to global frame at t = 0
   pos = pos + Rpos * tr';   Rpos = R * Rpos;
   
   %% Prepare frames for next iteration
   I1_l = I2_l;    I1_r = I2_r;
   
   %% Plot the odometry transformed data
   FInalPOISE=[Rpos pos];
   T = reshape(ground_truth(t, :), 4, 3)';
   pos_gt = T(:, 4);
   if showRoadMapYN
       
       axis([gt_x_min-20 gt_x_max+20 gt_z_min-20 gt_z_max+20])
       scatter(pos_gt(1), pos_gt(3), 'r', 'filled');
       hold on;
       scatter( - pos(1), pos(3), 'b', 'filled');
       
       title(sprintf('Odometry plot at frame %d', xx))
       xlabel('x-axis (in meters)');
       ylabel('z-axis (in meters)');
       
       if data_params.show_gt_flag
           legend('Ground Truth Pose', 'Estimated Pose')
       else
           legend('Estimated Pose')
       end
   end 

end
