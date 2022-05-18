#!/bin/bash
## @brief
## @author Gavin Chou
## @email  gavineaglechou@gmail.com
## @date   2021-01-06-Wed 14:24:36

# project setup
project_name=a-new-project
path_to_project=`pwd`/src/a-new-project
version='project-name-20210106'

# clean
rm -rf build && mkdir -p build && cd build
rm -rf "${project_name}"

 # genearte compile_commands.json for llvm, the project must be built with cmake
export CC=/opt/compiler/clang-10/bin/clang
export CXX=/opt/compiler/clang-10/bin/clang++
cmake "${path_to_project}" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

 # create html
build_directory="`pwd`"
output_directory="`pwd`/${project_name}"
data_directory="${output_directory}/../data"
source_directory="${path_to_project}"

 # errors will be skipped
codebrowser_generator -j 32 -b "${build_directory}" -a -o "${output_directory}" -p "${project_name}:${source_directory}:${version}"

 # make index.html for all entries
codebrowser_indexgenerator "${output_directory}"
