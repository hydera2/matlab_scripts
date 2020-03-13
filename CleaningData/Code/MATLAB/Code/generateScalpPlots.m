function generateScalpPlots(PSD)

length = size(PSD, 2);

for i=1:length
  display(strcat('Generating scalp plot #',num2str(i)));
  plot_scalp(PSD(:,i))
end

display('Finished.');

end