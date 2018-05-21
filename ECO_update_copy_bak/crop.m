function crop_img = crop(im_to_show,location)

if location(1) < 0
    location(1) = 0;
end
if location(2) < 0
    location(2) = 0;
end
if location(3) < 0
    location(3) = 0;
end
if location(4) < 0
    location(4) = 0;
end
crop_img = imcrop(im_to_show,location);