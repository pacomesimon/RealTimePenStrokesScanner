
images{1}=imread('1.jpg');

MyDelay=0.4;
pause(MyDelay)

for i=2:20
images{i}=imread(strcat(dec2base(i,2),'.jpg'));
imshow(images{i});

hold on
pause(MyDelay)
end