

subplot(1,3,1)
imshow(Part_1)
title('Part_1')

subplot(1,3,2)
imshow(Part_2)
title('Part_2')

% %%%%%%%%%%%%%%%%%%%%%%%%%%
image_2_final=Part_1+Part_2;
subplot(1,3,3)
imshow(image_2_final)
title('image 2 (final) = Part_1 + Part_2')