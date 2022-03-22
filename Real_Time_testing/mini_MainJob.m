global camp;
camp = 3;
global cam;
global fig;
fig = figure('Name','Final Year Project','KeyPressFcn',@closeFigure);
fig.WindowState='fullscreen';
%fig.WindowState='maximized';
fig.ToolBar='none';
fig.MenuBar='none';


images = cell(2,1);
global cropFactor;
global interFramesDelay;
global enhancement_multiplier;
global movement_sensitivity;
% % % % % % % % % % % % % % % % cropFactor=0.5;
% % % % % % % % % % % % % % % % interFramesDelay=0;
% % % % % % % % % % % % % % % % enhancement_multiplier=1.85;

global trigger;
trigger = true;

global rowCr1 rowCr2 colCr1 colCr2;

while (trigger)

    images{1}=snapshot(cam);
    rawImage1_Uncropped = images{1};
    [outputIm images{1} rowCr1 rowCr2 colCr1 colCr2]=mini_firstFrameFilter(images{1},cropFactor);
    
    global total_numberOfRows total_numberOfColumns
    total_numberOfRows=rowCr2 - rowCr1 + 1;
    total_numberOfColumns = colCr2 - colCr1 + 1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    global LP_filter_PS
    theRowPeriod = ceil((0.3/100) * total_numberOfRows);
    theColPeriod = ceil((0.3/100) * total_numberOfColumns);
    LP_filter_PS = (1/(theColPeriod*theRowPeriod)) * ones(theRowPeriod,theColPeriod);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    global Erosion_se Dilution_se
    theRowPeriod = ceil((0.1/100) * total_numberOfRows);
    theColPeriod = ceil((0.1/100) * total_numberOfColumns);
    Erosion_se = ones(theRowPeriod,theColPeriod);
    theRowPeriod = ceil((0.2/100) * total_numberOfRows);
    theColPeriod = ceil((0.2/100) * total_numberOfColumns);
    Dilution_se = ones(theRowPeriod,theColPeriod);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    global LP_filter_Hand
    theRowPeriod = ceil((5/100) * total_numberOfRows);
    theColPeriod = ceil((5/100) * total_numberOfColumns);
    LP_filter_Hand = (1/(theColPeriod*theRowPeriod)) * ones(theRowPeriod,theColPeriod);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    rawImage1 = rawImage1_Uncropped(rowCr1:rowCr2,colCr1:colCr2,:);
    cropCornerArea=uint16(5); % area cropped from the corner, in percentage;
    farthest_row = total_numberOfRows * cropCornerArea / 100 ;
    farthest_column = total_numberOfColumns * cropCornerArea / 100 ;
    cropCorner1{1}=rawImage1(1:farthest_row,1:farthest_column,:);
    cropCorner1{2}=rawImage1(1:farthest_row,end-farthest_column:end,:);
    cropCorner1{1}=rgb2gray(cropCorner1{1});
    cropCorner1{2}=rgb2gray(cropCorner1{2});
    Corner1{1}=histeq(cropCorner1{1});
    Corner1{2}=histeq(cropCorner1{2});
    Corner1{1}=imbinarize(Corner1{1},0.5);
    Corner1{2}=imbinarize(Corner1{2},0.5);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    global N_smoothing Erosion_se N_erosion Dilution_se N_dilution
    N_smoothing = 1;
    N_erosion = 1;
    N_dilution = 1;
    images{1}=mini_imagesProcessor(images{1},rawImage1,enhancement_multiplier,LP_filter_PS,N_smoothing,Erosion_se,N_erosion,Dilution_se,N_dilution,LP_filter_Hand);
    figure(fig)
    imshow(images{1});
    hold on
    pause(interFramesDelay)

    checker=true;

    
    while (trigger)
        a=2-checker;
        b=checker+1;
        images{b}=snapshot(cam);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        rawImage2 = images{b}(rowCr1:rowCr2,colCr1:colCr2,:);
        cropCorner2{1}=rawImage2(1:farthest_row,1:farthest_column,:);
        cropCorner2{2}=rawImage2(1:farthest_row,end-farthest_column:end,:);
        cropCorner2{1}=rgb2gray(cropCorner2{1});
        cropCorner2{2}=rgb2gray(cropCorner2{2});
        Corner2{1}=histeq(cropCorner2{1});
        Corner2{2}=histeq(cropCorner2{2});
        Corner2{1}=imbinarize(Corner2{1},0.5);
        Corner2{2}=imbinarize(Corner2{2},0.5);
        xor_from_corner1=xor((Corner1{1}(:)),(Corner2{1}(:)));
        xor_from_corner2=xor((Corner1{2}(:)),(Corner2{2}(:)));

        sum_xor_from_corner1=sum(xor_from_corner1(:));
        sum_xor_from_corner2=sum(xor_from_corner2(:));

        ratio_xor_from_corner1 = sum_xor_from_corner1/length(xor_from_corner1);
        ratio_xor_from_corner2 = sum_xor_from_corner2/length(xor_from_corner2);
        
        movementDetector = ((ratio_xor_from_corner1 > movement_sensitivity) || (ratio_xor_from_corner2 > movement_sensitivity));
        if movementDetector == true
            figure(fig)
%             beep;
            imshow(0.8*images{a});
%             beep;
                beep;pause(1);beep;pause(2);
            break;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        images{b}=mini_imagesProcessor(images{a},images{b}(rowCr1:rowCr2,colCr1:colCr2,:),enhancement_multiplier,LP_filter_PS,N_smoothing,Erosion_se,N_erosion,Dilution_se,N_dilution,LP_filter_Hand);
        figure(fig)
        imshow(images{b});

        hold on
        pause(interFramesDelay)
        checker = ~(checker);
    end
end

