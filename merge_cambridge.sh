#!/bin/bash
#Script for merging the splitted pdf files of Cambridge E-book in Mac OS
#Requirement: Automator, img2pdf(package from python)

book_zip=$(ls *zip)
if [ x"$book_zip" == x ]; then
  echo "No book archieves is found."
else
  book_num=$(echo $book_zip |grep -o 'cambridge-core_'|wc -l)
  echo "$book_num book archieves is found. Now begin to merge."
  book_list=$(echo $book_zip|sed 's/\.zip//g')
  echo "================================================================"
  progress=0
  for i in ${book_list}
  do
    book=$(echo $i|sed 's/cambridge-core_//g'|sed 's/_[0-9]\{1,2\}[A-Z][a-z]\{2\}20[0-9]\{2\}//g')
    name_len=${#book}
    left_len=$((31-($name_len+1)/2))
    if [ $left_len -lt 0 ]; then
      left_len=0
      right_len=0
    else
      right_len=$((31-$name_len/2))
    fi
    echo -n "="
    eval $(echo printf '" %0.s"' {1..$left_len})
    echo -n "$book"
    eval $(echo printf '" %0.s"' {1..$right_len})
    echo -e "=\n================================================================"
    left_len=$(($progress*59/$book_num))
    right_len=$((59-$left_len))
    progress_percent=$(($progress*100/$book_num))
    eval $(echo printf '"#%0.s"' {1..$left_len})
    eval $(echo printf '" %0.s"' {1..$right_len})
    echo -ne "($progress_percent%)\r"
    mkdir $i
    cd $i
    mv ../$i.zip ../$i.jpg .
    unzip -q $i.zip
    img2pdf -o 00.pdf $i.jpg
    /System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py -o ${book}.pdf  *.pdf
    mv ${book}.pdf ..
    cd ..
    rm -rf ${i}
    progress=$(($progress+1))
  done
fi

echo "###########################################################(100%)"
echo "Done!"
