function [weight1,weight2] = correlation(img1,img2,pre_img)

[h,w,c] = size(pre_img);
img1 = imresize(img1,[h,w]);
img2 = imresize(img2,[h,w]);
if c > 1
    gimg1 = rgb2gray(img1);
    gimg2 = rgb2gray(img2);
    gpre_img = rgb2gray(pre_img);
    weight1 = abs(corr2(gimg1,gpre_img));
    weight2 = abs(corr2(gimg2,gpre_img));
elseif c == 1
    weight1 = abs(corr2(img1,pre_img));
    weight2 = abs(corr2(img2,pre_img));
end

w1 = weight1;
w2 = weight2;

if (w1 == 0) && (w2 == 0)
    weight1 = 0.5;
    weight2 = 0.5;
else
    weight1 = w1/(w1 + w2);
    weight2 = w2/(w1 + w2);
end