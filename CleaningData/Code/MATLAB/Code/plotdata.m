function plot1 = plotdata(data, starttime, endtime) 
%change the amplitude
amplitude = 5;
[timepoints numchan] = size(data);
hold on
starttimepoint = 250*starttime;
endtimepoint = 250*endtime;
x= linspace(0, 1, timepoints);
for i = 1:numchan
    datacol = data(:,i)+ amplitude*i;
    xax = x(starttimepoint:endtimepoint);
    yax = datacol(starttimepoint:endtimepoint);
    plot1 = plot(xax,yax);
end
hold off 
