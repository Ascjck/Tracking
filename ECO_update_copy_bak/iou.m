function [weight1,weight2] = iou(box1,box2,gt_box)

weight1 = bboxOverlapRatio(box1,gt_box,'Union');

weight2 = bboxOverlapRatio(box2,gt_box,'Union');

if (weight1==0) && (weight2 == 0)
    weight1 = 0.5; weight2= 0.5;
end