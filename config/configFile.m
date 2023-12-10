%% ------------------------------------------------------------------------------
% Configuration File for Visual Odometry Algorithm
%% -------------------------------------------------------------------------------

% Path to the directories containing images

data_params.path1 = '/media/aghagol/9C9E6F459E6F16D4/Drive E/New folder/Erfan Salehi/DATASET/10/image_0/';
data_params.path2 = '/media/aghagol/9C9E6F459E6F16D4/Drive E/New folder/Erfan Salehi/DATASET/10/image_1/';

% Path to calibration text file
data_params.calib_file = 'C:\Users\Erfan\Downloads\archive(5)\Dataset\CameraCalibrationPar/calib.txt';

% Path to groundtruth poses. Set flag to 1 to plot groundtruth as well
data_params.gt_file = 'C:\Users\Erfan\Downloads\archive(5)\Dataset\GroundTruthPose/00.txt';
data_params.show_gt_flag = 1;

% Use parallel threads (requires Parallel Processing Toolbox)
% !! TO-DO: fix parfor and for loops for this functionality!
data_params.use_multithreads = 1;                % 0: disabled, 1: enabled

%% Read the calibration file to find parameters of the cameras
% !! TO-DO: Read from the calib_file instead

% calibration parameters for sequence 2010_03_09_drive_0000
cam_params.fx = 7.188560000000e+02;               % focal length (u-coordinate) in pixels
cam_params.cx = 6.071928000000e+02;               % principal point (u-coordinate) in pixels
cam_params.fy = 7.188560000000e+02;               % focal length (v-coordinate) in pixels
cam_params.cy = 1.852157000000e+02;               % principal point (v-coordinate) in pixels
cam_params.base = 3.861448000000e+02;             % baseline in meters (absolute value)
% 3.861448000000e+02; 

%% Paramters for Feature Selection using bucketing
vo_params.bucketing.max_features = 1;             % maximal number of features per bucket
vo_params.bucketing.bucket_width = 50;            % width of bucket
vo_params.bucketing.bucket_height = 50;           % height of bucket
% !! TO-DO: add feature selection based on feature tracking
vo_params.bucketing.age_threshold = 10;           % age threshold while feature selection

%% Paramters for motion estimation
% !! TO-DO: use Nister's algorithm for Rotation estimation (along with SLERP) and
% estimate translation using weighted optimization equation
vo_params.estim.ransac_iters = 200;              % number of RANSAC iterations
vo_params.estim.inlier_threshold = 2.0;          % fundamental matrix inlier threshold
vo_params.estim.reweighing = 1;                  % lower border weights (more robust to calibration errors)
