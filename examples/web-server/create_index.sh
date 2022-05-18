#!/bin/bash
## @brief
## @author Gavin Chou
## @email  gavineaglechou@gmail.com
## @date   2020-05-26-Tue


for i in `\ls | grep -v index.html | grep -v data | grep -v create_index.sh`; do
	echo "<a href=\"./$i\">$i<br/></a>"
done > index.html
