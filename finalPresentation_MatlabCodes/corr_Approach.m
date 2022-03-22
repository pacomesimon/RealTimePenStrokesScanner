function corr_Approach(image)
correlation_from_corner1=corr(double(image(:)),double(image(:)));
correlation_from_corner2=corr(double(image(:)),double(image(:)));
Decision_ = ((correlation_from_corner1 > 0.65) && (correlation_from_corner2 > 0.65));
end