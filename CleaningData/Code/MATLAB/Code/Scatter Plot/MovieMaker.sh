#!/bin/bash -l

echo
echo " Encoding : "$2
echo " AVI ..."
echo

for pass in 1 2 
 do
   echo
   echo " *** PASS $pass ***"
   echo

   mencoder "mf://$1.png" -o $2.avi -mf fps=$3:type=png -ovc lavc -lavcopts vcodec=mpeg4:keyint=4:vbitrate=15000:vpass=$pass

done

echo
echo " AVI DONE !!!"
echo
# echo " FLV ..."
# echo

# mencoder $2.avi -o $2.flv -of lavf -ovc lavc -lavcopts vcodec=flv:keyint=4:vbitrate=15000:mbd=2:mv0:trell:v4mv:cbp:last_pred=3

# # echo
# # echo " FLV DONE !!!"
# echo " GIF ..."
# echo

# #convert -resize 75% -delay $4 -loop 0  $1.png  $2.gif
# #convert -resize 50% -delay $4 -loop 0  $1.png  $2.gif
# convert -resize 33% -delay $4 -loop 0  $1.png  $2.gif

# echo
# echo " GIF DONE !!!"
# echo

rm -f divx2pass.log



