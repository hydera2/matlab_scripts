function plot_scalp(data)
%clock
rows = 200;
im = zeros(rows,rows);
result = getElectrodePositions(rows,rows);

%channels = {'F9';	'A1';'P9';'FP1';	'F7';'T7';	'P7';'O1';'F3';			'C3';			'P3';			'FPz';			'Fz';			'Cz';			'Pz';			'Oz';			'F4';		'C4';			'P4';			'FP2';			'F8';			'T8';			'P8';			'O2';			'F10';			'A2';			'P10'};
channels = {'F10'; 'AF4'; 'F2'; 'FCz'; 'FP2'; 'Fz'; 'FC1'; 'AFz' ; 'F1'; 'FP1'; 'AF3'; 'F3'; 'F5'; 'FC5'; 'FC3'; 'C1';
            'F9'; 'F7'; 'FT7'; 'C3'; 'CP1'; 'C5'; 'T9'; 'T7' ; 'TP7'; 'CP5'; 'P5'; 'P3'; 'TP9'; 'P7'; 'P1'; 'P9';
            'PO3'; 'Pz'; 'O1'; 'POz'; 'Oz'; 'PO4'; 'O2'; 'P2' ; 'CP2'; 'P4'; 'P10'; 'P8'; 'P6'; 'CP6'; 'TP10'; 'TP8';
            'C6'; 'C4'; 'C2'; 'T8'; 'FC4'; 'FC2'; 'T10'; 'FT8' ; 'FC6'; 'F8'; 'F6'; 'F4'; 'FT10'; 'AF8'; 'AF7'; 'FT9'
           };
[nElec junk] = size(channels);
%data = rand(nElec,1);
%data = PSD(:,2);

x=[];
y=[];
z=[];
for k=1:nElec
	idx = find(strcmp({result{:,1}}, {channels{k}}));
	to = result{idx,2};
	x= [x; to(1)];
	y= [y; to(2)];
	z = [z; data(k)];
	im(to(1)-2:to(1)+2,to(2)-2:to(2)+2) = 1;
end


amp = zeros(nElec, nElec);
for i=1:nElec
	for j=1:nElec
		if(i~=j)
			dist = sqrt((x(i)-x(j))*(x(i)-x(j)) + (y(i)-y(j))*(y(i)-y(j)));
			if(dist>= 0.0001)
				amp(i,j) = dist*dist * (log(dist)-1);
			end
		end
	end
end

% amp *w = z
% w = inv(amp) *z; it is both faster and more accurate to
% solve systems of equations (A*x = b) with 'Y = A \ b', rather than
% 'Y = inv (A) * b'.
% w = amp\z;
w = pinv(amp)*z;
[xx,yy] = meshgrid (linspace (1,rows,rows));
Zi = zeros(rows,rows);

origin = [round(rows/2), round(rows/2)];
rad = origin - 5;
grad = round(rad/6);
rad1 = rad- grad;

for i=1:rows
	for j=1:rows
		dist = sqrt((i-origin(1))*(i-origin(1)) + (j-origin(2))*(j-origin(2)));
		if(dist <rad)
			for k=1:nElec
				dist = sqrt((xx(i,j)-x(k))*(xx(i,j)-x(k)) + (yy(i,j)-y(k))*(yy(i,j)-y(k)));
				a(k) = dist*dist * (log(dist)-1);
			end
			Zi(i,j) = sum(a'.*w);
		end
	end
end

% [Xi,Yi,Zi] = griddata(x,y,z,xx,yy); 

%draw a circle
t= linspace(0,2*pi,7*rad1(1))';
circsx = round(rad1(1).*cos(t) +origin(1)+1);
circsy = round(rad1(2).*sin(t) +origin(2)+1);
for i=1:length(circsx)
	Zi(circsx(i),circsy(i)) = 1;
end

%draw nose lines
Nose = origin - [5.5*grad(1) 0];

F1 = origin +[-round(rad1(1)*cos(pi/10) ) -round(rad1(2)*sin(pi/10))];
for x=Nose(1):0.1:F1(1)
	y = ((Nose(2)-F1(2))/(Nose(1)-F1(1)))*(x - F1(1)) + F1(2);
	Zi(round(x),round(y))=1;
end

F1 = origin +[-round(rad1(1)*cos(pi/10) ) +round(rad1(2)*sin(pi/10))];
for x=Nose(1):0.1:F1(1)
	y = ((Nose(2)-F1(2))/(Nose(1)-F1(1)))*(x - F1(1)) + F1(2);
	Zi(round(x),round(y))=1;
end

%draw ears
%{
a = grad(1);
b = grad(2)/4;
c = origin + [0 5.5*grad(2)];
t =-pi:0.1:pi;
x = c(1) + a*cos(t);
y = c(2) + b*sin(t);
Zi(round(x), round(y))=1;
%}

figure
imagesc(Zi)
colormap ('default');
colorbar();
axis off;

% Determine band type
bandType = data(65);
if (bandType == 0)
	plotTitle = 'delta';
elseif (bandType == 1)
	plotTitle = 'theta';
elseif (bandType == 2)
	plotTitle = 'alpha';
elseif (bandType == 3)
	plotTitle = 'beta';
else
	plotTitle = '???';
end

title(plotTitle, 'fontsize', 20); % Print delta, theta, alpha, beta

%clock
end