AZ = -100;%-100
EL = 30;

view([AZ, EL])
%axis([-4 4 -4 4 -4 4]);
axis vis3d
degStep = 5;
detlaT = 0.3;
fCount = 71;
f = getframe(gcf);
[im,map] = rgb2ind(f.cdata,256,'nodither');
im(1,1,1,fCount) = 0;
k = 1;

daObj=VideoWriter('Scatter_plot_video_2','MPEG-4'); %my preferred format
daObj.FrameRate=3;
% open object, preparatory to making the video
open(daObj);

% spin left
for i = AZ:-degStep:AZ-360
  AZ = i;
  view([AZ,EL])
  f = getframe(gcf);
  im(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
  k = k + 1;
  
 writeVideo(daObj,getframe(gcf)); %use figure, since axis changes size based on view
end

%% clean up
close(daObj);
imwrite(im,map,'Animation_2.gif','DelayTime',detlaT,'LoopCount',inf)

