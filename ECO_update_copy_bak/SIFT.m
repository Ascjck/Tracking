function [weight1,weight2] = SIFT(img1,img2,pre_img)

[h,w,c] = size(pre_img);
%img1 = imresize(img1,[224,224]);
%img2 = imresize(img2,[224,224]);
%pre_img = imresize(pre_img,[224,224]);

if c > 1
    img1 = single(rgb2gray(img1));
    img2 = single(rgb2gray(img2));
    pre_img = single(rgb2gray(pre_img));
elseif c == 1
    img1 = single(img1);
    img2 = single(img2);
    pre_img = single(pre_img);
end

[fimg1, dimg1] = vl_sift(img1) ;
[fimg2, dimg2] = vl_sift(img2) ;
[fimgp, dimgp] = vl_sift(pre_img) ;
[matches1, scores1] = vl_ubcmatch(dimg1, dimgp, 1.5) ;
[matches2, scores2] = vl_ubcmatch(dimg2, dimgp, 1.5) ;

size1 = size(scores1);
size2 = size(scores2);

w1 = size1(2);
w2 = size2(2);

if (w1 == 0) && (w2 == 0)
    weight1 = 0.5;
    weight2 = 0.5;    
elseif (w1 <= 5) || (w2 <= 5)
    weight1 = 0.5;
    weight2 = 0.5;
else
    weight1 = w1/(w1 + w2);
    weight2 = w2/(w1 + w2);
end

