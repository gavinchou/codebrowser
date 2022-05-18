#!/bin/bash
## @brief
## @author Gavin Chou
## @email  gavineaglechou@gmail.com
## @date   2020-05-26-Tue

# if there are spaces in the first argument, spaning withou quote will damage
# arges
ag "$@" --html | awk -F: '{print $1"\""$3}' \
	| awk -F'"' '{print "<a href=\"./code/" $1"#" $3"\">"substr($1, 0, length($1)-5)":"$3"</a><br/><p/>"}' \
	| sort

# 	| awk -F'"' '{print "<a href=\"./code/" $1"#" $3"\">"substr($1, 0, length($1)-5)":"$3"</a>"; print substr($0, length($1) + 2)"\"</a></td></tr>"}' \
# 	| ag -vi '^<a'

# vim: tw=10086:
