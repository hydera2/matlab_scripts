#!/usr/local/bin/gnuplot -persist
#
#    
#    	G N U P L O T
#    	Version 4.2 patchlevel 4 
#    	last modified Sep 2008
#    	System: Darwin 9.7.0
#    
#    	Copyright (C) 1986 - 1993, 1998, 2004, 2007, 2008
#    	Thomas Williams, Colin Kelley and many others
#    
#    	Type `help` to access the on-line reference manual.
#    	The gnuplot FAQ is available from http://www.gnuplot.info/faq/
#    
#    	Send bug reports and suggestions to <http://sourceforge.net/projects/gnuplot>
#    

#set term X11
#set output

unset clip points
set clip one
unset clip two
set bar 1.000000
set xdata
set ydata
set zdata
set x2data
set y2data
set timefmt x "%d/%m/%y,%H:%M"
set timefmt y "%d/%m/%y,%H:%M"
set timefmt z "%d/%m/%y,%H:%M"
set timefmt x2 "%d/%m/%y,%H:%M"
set timefmt y2 "%d/%m/%y,%H:%M"
set timefmt cb "%d/%m/%y,%H:%M"
set boxwidth
set dummy x,y
set format x "% g"
set format y "% g"
set format x2 "% g"
set format y2 "% g"
set format z "% g"
set format cb "% 3g"
set angles radians
unset grid
set key title ""
#unset label
unset arrow
set view 60, 30, 1, 1
set view map
set autoscale
set samples 100, 100
set isosamples 10, 10
set surface
unset contour
set mapping cartesian
set datafile separator whitespace
unset hidden3d
set cntrparam order 4
set cntrparam linear

set cntrparam levels auto 5
set cntrparam points 5
set size ratio 1 2,2
set origin 0,0
set style data pm3d
set style function pm3d

set xrange [ * : * ] noreverse nowriteback
set yrange [ * : * ] noreverse nowriteback

set zero 1e-08
set lmargin  -1
set bmargin  -1
set rmargin  -1
set tmargin  -1
set locale "C"
#set pm3d implicit at b
#set pm3d scansautomatic
#set pm3d 1,1 flush begin noftriangles nohidden3d corners2color mean
set palette positive nops_allcF maxcolors 0 gamma 1.5 color model RGB 
set palette defined ( 0 0 0 0, 0.4444 0 0 1, 0.6667 1 0 0,\
     0.7333 1 0.6471 0, 0.8 1 1 0, 0.8889 0 1 0, 1 0 0.3922 0 )
set loadpath 
set fontpath 
set fit noerrorvariables

set view map
set style data pm3d
set style function pm3d

set size square 1,1
set origin 0,0

set pm3d at b

###########################################################################################
set xrange [ 0 : 50 ] noreverse
set yrange [ 0 : 50 ] noreverse
set xrange [ * : * ] noreverse
set yrange [ * : * ] noreverse

set cbrange [ 5 : 9 ]
#set cbrange [ 4 : 8 ]

set xtics autofreq
set ytics autofreq
set cbtics 1

set palette rgbformulae 21,22,23

set xlabel " X  [Mpc] " offset 0,-1
set ylabel " Y  [Mpc] " offset -3,0
set cblabel " Log( Gas Column Density  -  [ Msun / kpc2 ] ) " offset 2,0

#set colorbox vert user origin .848,.166 size .03,.684
set colorbox vert user origin .852,.159 size .026,.696
#set colorbox vert user origin .852,.155 size .026,.687
#set colorbox vert user origin .84,.164 size .03,.67

set xlabel ""
set ylabel ""
set cblabel ""
unset xtics
unset ytics
unset colorbox
#unset label
###########################################################################################
set term png enhanced notransparent font ",24" size 2560,2560 crop #xffffff x000000 xffffff
set term png enhanced notransparent font ",24" size 640,640 crop #xffffff x000000 xffffff
set term png enhanced notransparent font ",24" size 320,320 crop #xffffff x000000 xffffff
set term png enhanced notransparent font ",24" size 1280,1280 crop #xffffff x000000 xffffff
set output 'OUT/NAME_BOX_Rho_XY_000.png'
###########################################################################################
#set label 1" z = RED " at 0.25,YLAB left front tc rgb "white"
#set label 2 " Density " at XLAB,YLAB center front tc rgb "white"

splot "b.csv" \
nonuniform matrix using 2:1:3 notitle
###########################################################################################

#    EOF
