function result = getElectrodePositions(rows,cols)
origin = [round(rows/2), round(cols/2)];
rad = origin - 5;
grad = round(rad/6);
rad1 = rad - grad;
rad2 = rad - 2*grad;
rad3 = rad - 3*grad;

st=1;
%% -- bottom left
Cz = origin;
result{st,1}='Cz'; result{st,2}=Cz;st=st+1;
CPz = origin + [grad(1) 0];
result{st,1}='CPz'; result{st,2}=CPz;st=st+1;
Pz = origin + [2*grad(1) 0];
result{st,1}='Pz'; result{st,2}=Pz;st=st+1;
POz = origin + [3*grad(1) 0];
result{st,1}='POz'; result{st,2}=POz;st=st+1;
Oz = origin + [4*grad(1) 0];
result{st,1}='Oz'; result{st,2}=Oz;st=st+1;
Iz = origin + [5*grad(1) 0];
result{st,1}='Iz'; result{st,2}=Iz;st=st+1;
C1 = origin -  [0 grad(2)];
result{st,1}='C1'; result{st,2}=C1;st=st+1;
C3 = origin - [0 2*grad(2)];
result{st,1}='C3'; result{st,2}=C3;st=st+1;
C5 = origin - [0 3*grad(2)];
result{st,1}='C5'; result{st,2}=C5;st=st+1;
T7 = origin - [0 4*grad(2)];
result{st,1}='T7'; result{st,2}=T7;st=st+1;
T9 = origin - [0 5*grad(2)];
result{st,1}='T9'; result{st,2}=T9;st=st+1;

TP9 = origin +[round(rad1(1)*cos(4*pi/10) ) -round(rad1(2)*sin(4*pi/10))];
result{st,1}='TP9'; result{st,2}=TP9;st=st+1;
P9 = origin +[round(rad2(1)*cos(3*pi/10) ) -round(rad2(2)*sin(3*pi/10))];
result{st,1}='P9'; result{st,2}=P9;st=st+1;

O1 = origin +[round(rad2(1)*cos(pi/10) ) -round(rad2(2)*sin(pi/10))];
result{st,1}='O1'; result{st,2}=O1;st=st+1;
PO7 = origin +[round(rad2(1)*cos(2*pi/10) ) -round(rad2(2)*sin(2*pi/10))];
result{st,1}='PO7'; result{st,2}=PO7;st=st+1;
P7 = origin +[round(rad2(1)*cos(3*pi/10) ) -round(rad2(2)*sin(3*pi/10))];
result{st,1}='P7'; result{st,2}=P7;st=st+1;
TP7 = origin +[round(rad2(1)*cos(4*pi/10) ) -round(rad2(2)*sin(4*pi/10))];
result{st,1}='TP7'; result{st,2}=TP7;st=st+1;

PO3 =  origin +[3*grad(1) -round(rad3(2)*sin(3*pi/20))];
result{st,1}='PO3'; result{st,2}=PO3;st=st+1;

CP1 = origin +[round(3*grad(1)/4)+round(rad2(1)*cos(4*pi/10)/4) -round(rad2(2)*sin(4*pi/10)/4)];
result{st,1}='CP1'; result{st,2}=CP1;st=st+1;
CP3 = origin +[round(grad(1)/2)+round(rad2(1)*cos(4*pi/10)/2) -round(rad2(2)*sin(4*pi/10)/2)];
result{st,1}='CP3'; result{st,2}=CP3;st=st+1;
CP5 = origin +[round(grad(1)/4)+round(rad2(1)*cos(4*pi/10)*3/4) -round(rad2(2)*sin(4*pi/10)*3/4)];
result{st,1}='CP5'; result{st,2}=CP5;st=st+1;

P1 = origin +[round(3*grad(1)/2)+round(rad2(1)*cos(3*pi/10)/4) -round(rad2(2)*sin(3*pi/10)/4)];
result{st,1}='P1'; result{st,2}=P1;st=st+1;
P3 = origin +[grad(1)+round(rad2(1)*cos(3*pi/10) /2) -round(rad2(2)*sin(3*pi/10)/2)];
result{st,1}='P3'; result{st,2}=P3;st=st+1;
P5 = origin +[round(grad(1)/2)+round(rad2(1)*cos(3*pi/10)*3/4) -round(rad2(2)*sin(3*pi/10)*3/4)];
result{st,1}='P5'; result{st,2}=P5;st=st+1;
%%-----bottom right
FCz = origin - [grad(1) 0];
result{st,1}='FCz'; result{st,2}=FCz;st=st+1;
Fz = origin - [2*grad(1) 0];
result{st,1}='Fz'; result{st,2}=Fz;st=st+1;
AFz = origin - [3*grad(1) 0];
result{st,1}='AFz'; result{st,2}=AFz;st=st+1;
FPz = origin - [4*grad(1) 0];
result{st,1}='FPz'; result{st,2}=FPz;st=st+1;
Nz = origin - [5*grad(1) 0];
result{st,1}='Nz'; result{st,2}=Nz;st=st+1;
C2 = origin+ [0 grad(2)];
result{st,1}='C2'; result{st,2}=C2;st=st+1;
C4 = origin + [0 2*grad(2)];
result{st,1}='C4'; result{st,2}=C4;st=st+1;
C6 = origin + [0 3*grad(2)];
result{st,1}='C6'; result{st,2}=C6;st=st+1;
T8 = origin + [0 4*grad(2)];
result{st,1}='T8'; result{st,2}=T8;st=st+1;
T10 = origin + [0 5*grad(2)];
result{st,1}='T10'; result{st,2}=T10;st=st+1;

TP10 = origin +[round(rad1(1)*cos(4*pi/10) ) +round(rad1(2)*sin(4*pi/10))];
result{st,1}='TP10'; result{st,2}=TP10;st=st+1;
P10 = origin +[round(rad2(1)*cos(3*pi/10) ) +round(rad2(2)*sin(3*pi/10))];
result{st,1}='P10'; result{st,2}=P10;st=st+1;

O2 = origin +[round(rad2(1)*cos(pi/10) ) +round(rad2(2)*sin(pi/10))];
result{st,1}='O2'; result{st,2}=O2;st=st+1;
PO8 = origin +[round(rad2(1)*cos(2*pi/10) ) +round(rad2(2)*sin(2*pi/10))];
result{st,1}='PO8'; result{st,2}=PO8;st=st+1;
P8 = origin +[round(rad2(1)*cos(3*pi/10) ) +round(rad2(2)*sin(3*pi/10))];
result{st,1}='P8'; result{st,2}=P8;st=st+1;
TP8 = origin +[round(rad2(1)*cos(4*pi/10) ) +round(rad2(2)*sin(4*pi/10))];
result{st,1}='TP8'; result{st,2}=TP8;st=st+1;

PO4 =  origin +[3*grad(1) +round(rad3(2)*sin(3*pi/20))];
result{st,1}='PO4'; result{st,2}=PO4;st=st+1;

CP2 = origin +[round(3*grad(1)/4)+round(rad2(1)*cos(4*pi/10)/4) +round(rad2(2)*sin(4*pi/10)/4)];
result{st,1}='CP2'; result{st,2}=CP2;st=st+1;
CP4 = origin +[round(grad(1)/2)+round(rad2(1)*cos(4*pi/10)/2) +round(rad2(2)*sin(4*pi/10)/2)];
result{st,1}='CP4'; result{st,2}=CP4;st=st+1;
CP6 = origin +[round(grad(1)/4)+round(rad2(1)*cos(4*pi/10)*3/4) +round(rad2(2)*sin(4*pi/10)*3/4)];
result{st,1}='CP6'; result{st,2}=CP6;st=st+1;

P2 = origin +[round(3*grad(1)/2)+round(rad2(1)*cos(3*pi/10)/4) +round(rad2(2)*sin(3*pi/10)/4)];
result{st,1}='P2'; result{st,2}=P2;st=st+1;
P4 = origin +[grad(1)+round(rad2(1)*cos(3*pi/10) /2) +round(rad2(2)*sin(3*pi/10)/2)];
result{st,1}='P4'; result{st,2}=P4;st=st+1;
P6 = origin +[round(grad(1)/2)+round(rad2(1)*cos(3*pi/10)*3/4) +round(rad2(2)*sin(3*pi/10)*3/4)];
result{st,1}='P6'; result{st,2}=P6;st=st+1;

%% -- top left
FT9 = origin +[-round(rad1(1)*cos(4*pi/10) ) -round(rad1(2)*sin(4*pi/10))];
result{st,1}='FT9'; result{st,2}=FT9;st=st+1;
F9 = origin +[-round(rad2(1)*cos(3*pi/10) ) -round(rad2(2)*sin(3*pi/10))];
result{st,1}='F9'; result{st,2}=F9;st=st+1;

FP1 = origin +[-round(rad2(1)*cos(pi/10) ) -round(rad2(2)*sin(pi/10))];
result{st,1}='FP1'; result{st,2}=FP1;st=st+1;
AF7 = origin +[-round(rad2(1)*cos(2*pi/10) ) -round(rad2(2)*sin(2*pi/10))];
result{st,1}='AF7'; result{st,2}=AF7;st=st+1;
F7 = origin +[-round(rad2(1)*cos(3*pi/10) ) -round(rad2(2)*sin(3*pi/10))];
result{st,1}='F7'; result{st,2}=F7;st=st+1;
FT7 = origin +[-round(rad2(1)*cos(4*pi/10) ) -round(rad2(2)*sin(4*pi/10))];
result{st,1}='FT7'; result{st,2}=FT7;st=st+1;

AF3 =  origin +[-3*grad(1) -round(rad3(2)*sin(3*pi/20))];
result{st,1}='AF3'; result{st,2}=AF3;st=st+1;

FC1 = origin +[-round(3*grad(1)/4)-round(rad2(1)*cos(4*pi/10)/4) -round(rad2(2)*sin(4*pi/10)/4)];
result{st,1}='FC1'; result{st,2}=FC1;st=st+1;
FC3 = origin +[-round(grad(1)/2)-round(rad2(1)*cos(4*pi/10)/2) -round(rad2(2)*sin(4*pi/10)/2)];
result{st,1}='FC3'; result{st,2}=FC3;st=st+1;
FC5 = origin +[-round(grad(1)/4)-round(rad2(1)*cos(4*pi/10)*3/4) -round(rad2(2)*sin(4*pi/10)*3/4)];
result{st,1}='FC5'; result{st,2}=FC5;st=st+1;

F1 = origin +[-round(3*grad(1)/2)-round(rad2(1)*cos(3*pi/10)/4) -round(rad2(2)*sin(3*pi/10)/4)];
result{st,1}='F1'; result{st,2}=F1;st=st+1;
F3 = origin +[-grad(1)-round(rad2(1)*cos(3*pi/10) /2) -round(rad2(2)*sin(3*pi/10)/2)];;
result{st,1}='F3'; result{st,2}=F3;st=st+1;
F5 = origin +[-round(grad(1)/2)-round(rad2(1)*cos(3*pi/10)*3/4) -round(rad2(2)*sin(3*pi/10)*3/4)];
result{st,1}='F5'; result{st,2}=F5;st=st+1;

%% -- top right
FT10 = origin +[-round(rad1(1)*cos(4*pi/10) )  round(rad1(2)*sin(4*pi/10))];
result{st,1}='FT10'; result{st,2}=FT10;st=st+1;
F10 = origin +[-round(rad2(1)*cos(3*pi/10) )  round(rad2(2)*sin(3*pi/10))];
result{st,1}='F10'; result{st,2}=F10;st=st+1;

FP2 = origin +[-round(rad2(1)*cos(pi/10) )  round(rad2(2)*sin(pi/10))];
result{st,1}='FP2'; result{st,2}=FP2;st=st+1;
AF8 = origin +[-round(rad2(1)*cos(2*pi/10) )  round(rad2(2)*sin(2*pi/10))];
result{st,1}='AF8'; result{st,2}=AF8;st=st+1;
F8 = origin +[-round(rad2(1)*cos(3*pi/10) )  round(rad2(2)*sin(3*pi/10))];
result{st,1}='F8'; result{st,2}=F8;st=st+1;
FT8 = origin +[-round(rad2(1)*cos(4*pi/10) )  round(rad2(2)*sin(4*pi/10))];
result{st,1}='FT8'; result{st,2}=FT8;st=st+1;

AF4 =  origin +[-3*grad(1) round(rad3(2)*sin(3*pi/20))];
result{st,1}='AF4'; result{st,2}=AF4;st=st+1;

FC2 = origin +[-round(3*grad(1)/4)-round(rad2(1)*cos(4*pi/10)/4)   round(rad2(2)*sin(4*pi/10)/4)];
result{st,1}='FC2'; result{st,2}=FC2;st=st+1;
FC4 = origin +[-round(grad(1)/2)-round(rad2(1)*cos(4*pi/10)/2)   round(rad2(2)*sin(4*pi/10)/2)];
result{st,1}='FC4'; result{st,2}=FC4;st=st+1;
FC6 = origin +[-round(grad(1)/4)-round(rad2(1)*cos(4*pi/10)*3/4)   round(rad2(2)*sin(4*pi/10)*3/4)];
result{st,1}='FC6'; result{st,2}=FC6;st=st+1;

F2 = origin +[-round(3*grad(1)/2)-round(rad2(1)*cos(3*pi/10)/4)   round(rad2(2)*sin(3*pi/10)/4)];
result{st,1}='F2'; result{st,2}=F2;st=st+1;
F4 = origin +[-grad(1)-round(rad2(1)*cos(3*pi/10) /2)    round(rad2(2)*sin(3*pi/10)/2)];
result{st,1}='F4'; result{st,2}=F4;st=st+1;
F6 = origin +[-round(grad(1)/2)-round(rad2(1)*cos(3*pi/10)*3/4)   round(rad2(2)*sin(3*pi/10)*3/4)];
result{st,1}='F6'; result{st,2}=F6;st=st+1;

A1 = origin - [0 6*grad(2)];
result{st,1}='A1'; result{st,2}=A1;st=st+1;

A2 = origin + [0 6*grad(2)];
result{st,1}='A2'; result{st,2}=A2;st=st+1;


end