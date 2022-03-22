global cam;
cam = 3;
global theFig;
% % % % % % % % % theFig = uifigure('Name','Final Year Project','Position',[140 145 700 500],'Icon','theIcon.png');
global g;
g = uigridlayout(theFig);
g.RowHeight = {'1x'};
% g.ColumnWidth = {150,'1x'};
g.ColumnWidth = {'1x','1x'};
global miPanel;
miPanel = uihtml(g,'HTMLSource','myHTMLfile.html');
miPanel.Position = [10 10 420 670];
% ddl.HTMLSource = fullfile(pwd,'myHTMLfile.html');
global ax;
ax = uiaxes(g);
ax.Title.String = "PREVIEW:";
myImag = imread("theIcon.png");
imshow(myImag,'Parent',ax);
  
global miData;
 miData.someDummyData="Useless data, type yours ...";
 
 miPanel.Data = jsonencode(miData);


miPanel.DataChangedFcn = @(src,event)miCommandProcessor(miPanel.Data);

global cropFactor;
global interFramesDelay;
global enhancement_multiplier;
global movement_sensitivity;
global camp;


camp = 3;
cropFactor=0.3;
interFramesDelay=0;
enhancement_multiplier=1.85;
movement_sensitivity=0.3;

global trigger frameNumber videoFrames frameTic frameT;

global obsThr; obsThr = 0.5;
global pensThr; pensThr = 235;

function miCommandProcessor(Data)
eval(Data);
end
  
  
  