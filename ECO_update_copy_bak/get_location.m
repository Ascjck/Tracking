function rect_position_vis = get_location(scores_fs,location_params,currentScaleFactor,sample_pos)

iterations = location_params{1}; img_support_sz = location_params{2};
output_sz = location_params{3}; min_scale_factor = location_params{4};
max_scale_factor = location_params{5};base_target_sz = location_params{6}; 
scaleFactors = location_params{7};
[trans_row, trans_col, max_scale_response,scale_ind] = optimize_scores(scores_fs, iterations); 
translation_vec = [trans_row, trans_col] .* (img_support_sz./output_sz) * currentScaleFactor * scaleFactors(scale_ind);
scale_change_factor = scaleFactors(scale_ind);
pos = sample_pos + translation_vec;
currentScaleFactor = currentScaleFactor * scale_change_factor;
if currentScaleFactor < min_scale_factor
    currentScaleFactor = min_scale_factor;
elseif currentScaleFactor > max_scale_factor
    currentScaleFactor = max_scale_factor;
end  
target_sz_vis = base_target_sz * currentScaleFactor;
rect_position_vis = [pos([2,1]) - (target_sz_vis([2,1]) - 1)/2, target_sz_vis([2,1])];