#!/bin/bash
#Script for merging the splitted pdf files of Cambridge E-book in Mac OS
#Requirement: Automator, img2pdf(package from python)

function progressBar() {
  full_len=$(($COLUMNS-6))
  bar_len=$(($1*$full_len/100))
  rest_len=$(($full_len-$bar_len))
  if [ $bar_len -ge 1 ]; then
    eval $(echo printf '"#%0.s"' {1..$bar_len})
  fi
  if [ $rest_len -ge 1 ]; then
    eval $(echo printf '" %0.s"' {1..$rest_len})
  fi
  printf "(%3d" ${1}
  echo -ne "%)\r"
}

tstart=$(date +%s)
book_zip=$(ls *.zip)
if [ x"$book_zip" == x ]; then
  echo "No book archieves is found."
else
  book_num=$(echo $book_zip |grep -o 'cambridge-core_'|wc -l)
  echo "$book_num book archieves are found. Now begin to merge."
  book_list=$(echo $book_zip|sed 's/\.zip//g')
  #echo "================================================================"
  eval $(echo printf '"=%0.s"' {1..$COLUMNS})
  progress=0
  for i in ${book_list}
  do
    book=$(echo $i|sed 's/cambridge-core_//g'|sed 's/_[0-9]\{1,2\}[A-Z][a-z]\{2\}20[0-9]\{2\}//g')
    name_len=${#book}
    left_len=$((($COLUMNS-4-$name_len)/2))
    echo -n "=="
    if [ $left_len -le 0 ]; then
      echo -n "$book"
    else
      eval $(echo printf '" %0.s"' {1..$left_len})
      echo -n "$book"
    fi
    right_len=$(($COLUMNS-4-$name_len-$left_len))
    if [ $right_len -gt 0 ]; then
      eval $(echo printf '" %0.s"' {1..$right_len})
    fi
    echo -n "=="
    eval $(echo printf '"=%0.s"' {1..$COLUMNS})
    progress_percent=$(($progress*100/$book_num))
    progressBar $progress_percent
    if [ ! -f $i.jpg ]; then
      if [ -f $i.gif ]; then
        sips -s format jpeg $i.gif --out $i.jpg >> /dev/null 2>>/tmp/cambridge.log
        rm $i.gif
      elif [ -f $i.png ]; then
        sips -s format jpeg $i.png --out $i.jpg >> /dev/null 2>>/tmp/cambridge.log
        rm $i.png
      fi
    fi
    progressBar $(($progress_percent+10/$book_num))
    mkdir $i
    cd $i
    mv ../$i.zip .
    unzip -q $i.zip
    if [ -f ../$i.jpg ]; then
      mv ../$i.jpg .
      img2pdf -o 00.pdf $i.jpg
    fi
    progressBar $(($progress_percent+20/$book_num))
    /System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py -o ${book}.pdf  *.pdf >>/dev/null 2>>/tmp/cambridge.log
    progressBar $(($progress_percent+90/$book_num))
    mv ${book}.pdf ..
    cd ..
    rm -rf ${i}
    progress=$(($progress+1))
  done
progressBar 100
tend=$(date +%s)
echo -e "\nDone! Finish in $((($tend-$tstart)/60))min$((($tend-$tstart)%60))sec."
fi
