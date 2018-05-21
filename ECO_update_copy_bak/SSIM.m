function [weight1,weight2] = SSIM(img1,img2,pre_img)

[h,w,c] = size(pre_img);
img1 = imresize(img1,[h,w]);
img2 = imresize(img2,[h,w]);

w1 = ssim(img1,pre_img);
w2 = ssim(img2,pre_img);

if w1 < 0
    weight1 = 0;
end
if w2 < 0
    weight2 = 0;
end
if (w1 == 0) && (w2 == 0)
    weight1 = 0.5;
    weight2 = 0.5;
else
    weight1 = w1/(w1 + w2);
    weight2 = w2/(w1 + w2);
end




