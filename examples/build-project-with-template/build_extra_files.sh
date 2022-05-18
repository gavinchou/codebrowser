#!/bin/bash
## @brief  Build extra files to codebrowser generated output
## @author Gavin
## @email  gavineaglechou@gmail.com
## @date   2022-05-18-Wed

# Prerequisites:
# 1. Current working directory is the same as build.sh
# 2. Vim is required


project_name=tmp
# Source code
path_to_project=
# It's usually ./ in ${path_to_project}, if it covers unnecessary files like
# third-party, narrow it down to a sub-folder of ${path_to_project}
gensrc_foler=./
output_extra=`pwd`/extra-files

# Generate html files with vim
cd ${path_to_project}
# find with file extensions
for e in `echo "*.proto *.thrift"`; do
  for i in `find ${gensrc_foler} -type f -iname "${e}"`; do
    # echo "${path_to_project}/${i}"
    o="${output_extra}/${i}.html"
    mkdir -p `dirname "${o}"`
    # Convert source to html with vim
    vim "${i}" -c ":TOhtml | :w! | :qa"
    # -es does not work
    # vim -e '+:TOhtml' '+:w' '+:qa' "${i}"-
    mv -f "${i}.html" "${o}"
    # change default font
    sed -ri 's/monospace;/Jetbrains Mono, Consolas, monospace; font-size: 13px;/g' "${o}"
  done
done
cd - > /dev/null

# Generate index.html for extra files, this step is optional
cd ${output_extra}
# tree . -T "Extra" --charset utf8 -H . -P "*html" -o index.html
tree . -T "Extra" --charset utf8 -H . -P "*html" | sed -r 's/\.html</</' > index.html
# Change font to monospace
sed -ri 's#font-family\s*:\s*[^;]+;#font-family:Jetbrains Mono, Consolas, monospace; font-size: 13px;#g' index.html
sed -ri 's#.VERSION \{ font-size: small;#.VERSION \{ font-size: 0;#g' index.html
cd - > /dev/null

# Update fileIndex of codebrowser,
# put extra files into codebrowser's directory structure
mv ${output_extra} ${project_name}/${project_name}/extra-files
cd ${project_name}
output_extra=${project_name}/extra-files
find ${output_extra} -type f -iname '*.html' | sed -r 's/.html$//' >> fileIndex
cd - > /dev/null

# vim: et tw=80 ts=2 sw=2 cc=80:
