
% This demo script runs the ECO tracker with hand-crafted features on the
% included "Crossing" video.

% Add paths
setup_paths();

% Load video information
%video_path = 'sequences/Crossing';
%video_path='/home/safe_data_dir/tracking/OTB/OTB50/Matrix';
video_path='sequences/Crossing';
[seq, ground_truth] = load_video_info(video_path);
% Run ECO
results = VOT2016_HC_settings(seq);
disp(results.res)