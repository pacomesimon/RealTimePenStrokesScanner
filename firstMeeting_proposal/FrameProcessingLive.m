
images{1}=imread('1.jpg');

cropFactor=0.95;%0.1
[outim images{1} row1 row2 col1 col2]=firstFrameFilter(images{1},cropFactor);

MyDelay=0.05;
pause(MyDelay)

ENHENCEMENTmultiplier=1.65;
figure(1)
for i=2:20
images{i}=imread(strcat(dec2base(i,2),'.jpg'));
subplot(1,2,1)
imshow(images{i})
images{i}=whitePaperProcessor(images{i-1},images{i}(row1:row2,col1:col2,:),ENHENCEMENTmultiplier);
subplot(1,2,2)
imshow(images{i});
% 
% hold on
pause(MyDelay)
end
close(1)