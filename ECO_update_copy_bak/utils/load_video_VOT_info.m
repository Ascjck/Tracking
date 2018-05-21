function [seq, ground_truth] = load_video_info(video_path)

ground_truth = dlmread([video_path '/groundtruth.txt']);

seq.len = size(ground_truth, 1);
seq.init_rect_ = ground_truth(1,:);
seq.init_rect=[seq.init_rect_(1),seq.init_rect_(2),seq.init_rect_(3)-seq.init_rect_(1),seq.init_rect_(6)-seq.init_rect_(2)]

img_path = [video_path];
disp([img_path num2str(1, '%08i.jpg')])

if exist([img_path num2str(1, '%08i.png')], 'file'),
    img_files = num2str((1:seq.len)', [img_path '%08i.png']);
elseif exist([img_path num2str(1, '%08i.jpg')], 'file'),
    img_files = num2str((1:seq.len)', [img_path '%08i.jpg']);
    disp(img_files)
elseif exist([img_path num2str(1, '%08i.bmp')], 'file'),
    img_files = num2str((1:seq.len)', [img_path '%08i.bmp']);
else
    error('No image files to load.')
end

seq.s_frames = cellstr(img_files);

end

