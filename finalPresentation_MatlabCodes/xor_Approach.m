function xor_Approach(image)
Corner1{1}= rgb2gray(image);
Corner1{2}= rgb2gray(image);
Corner2{1}= rgb2gray(image);
Corner2{2}= rgb2gray(image);

Corner1{1}=imbinarize(Corner1{1},0.5);
Corner1{2}=imbinarize(Corner1{2},0.5);
Corner2{1}=imbinarize(Corner2{1},0.5);
Corner2{2}=imbinarize(Corner2{2},0.5);
xor_from_corner1=xor((Corner1{1}(:)),(Corner2{1}(:)));
xor_from_corner2=xor((Corner1{2}(:)),(Corner2{2}(:)));

sum_xor_from_corner1=sum(xor_from_corner1(:));
sum_xor_from_corner2=sum(xor_from_corner2(:));

ratio_xor_from_corner1 = sum_xor_from_corner1/length(xor_from_corner1);
ratio_xor_from_corner2 = sum_xor_from_corner2/length(xor_from_corner2);

movementDetector = ((ratio_xor_from_corner1 > 0.3) || (ratio_xor_from_corner2 > 0.3));
end