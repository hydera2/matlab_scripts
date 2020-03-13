%change the number of seconds you want to plot under numseconds
numseconds = 10;
%change the amplitude
amplitude = 5;
[timepoints numchan] = size(data);
hold on

endtime = 250*numseconds
x= linspace(0, 1, timepoints);
for i = 1:numchan
    datacol = data(:,i)+ amplitude*i;
    plot(x(1:endtime),datacol(1:endtime));
end
hold off 
