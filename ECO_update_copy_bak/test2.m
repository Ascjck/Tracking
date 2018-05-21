I = imread('peppers.png');
c = [90,200,90,60];
figure(1);
imshow(I);
hold on
plot(90,200,'r*');
rectangle('Position',c);
rectangle('Position',c, 'EdgeColor','b', 'LineWidth',2);
b = imcrop(I,c);
figure(2),imshow(b);
disp(size(b));
axis on
% rectangle('Position',[1 2 5 6])
% plot(1,2,'r*');
% axis([0 10 0 10])