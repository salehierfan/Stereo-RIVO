function well_matches = NEWbucketFeatures(matches, bucketing_params,xx)

bucket_width = bucketing_params.bucket_width(1,xx);
bucket_height = bucketing_params.bucket_height(1,xx);
max_features = bucketing_params.max_features(1,xx);

% get locations of all matched points
locations2_l = [matches(:,2) matches(:,1)]';

% find max values
x_max = max(locations2_l(1, :));
y_max = max(locations2_l(2, :));

% allocate number of buckets needed
bucket_cols = ceil(y_max/bucket_width);
bucket_rows = ceil(x_max/bucket_height);

% create a array for bucket positions/class
buckets = cell(bucket_rows, bucket_cols);

% iterate over all keypoints
for i = 1:size(matches, 1)
    % coordinate of keypoint
    x = locations2_l(1,i);
    y = locations2_l(2,i);
    % find bin position
    bin_x = ceil(x/bucket_height);
    bin_y = ceil(y/bucket_width);
    % add keypoint index to corresponding bin_pos
    buckets{bin_x, bin_y} = horzcat(buckets{bin_x, bin_y}, i);
end

% % refill matches from buckets
indices = [];
for index = 1:length(buckets(:))
    [pos_x, pos_y] = ind2sub(size(buckets), index);
    if numel(buckets{pos_x, pos_y}) >= 2
        indices = horzcat(indices, datasample(buckets{pos_x, pos_y}, max_features,'Replace', false));
    else
        if numel(buckets{pos_x, pos_y}) == 1
            indices = horzcat(indices, buckets{pos_x, pos_y});
        end
    end
end
% 
 well_matches = matches(indices,:);
end