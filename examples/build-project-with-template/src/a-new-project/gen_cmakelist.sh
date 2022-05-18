#!/bin/bash
## @brief
## @author Gavin Chou
## @email  gavineaglechou@gmail.com
## @date   2021-01-06-Wed

project=new-project

# fill src_dir and inc_dir to generate CmakeLists.txt

# all folders that contain .cpp .c files
src_dir="
./src
./samples/
./3rdparty/
./sub/
./cli/
"

# all folders that contain .h .hpp files
# `find . -iname 'include'` to help
inc_dir="
./
./3rdparty/include
./include
./src/include
./src/util/include
./test/framework/include
./test/library/include
./test/test_apps/hsejni/include
"

proto_idl_dir=""
thrift_idl_dir=""

## the following is template, do not modify unless you know what will happen
src_dir="${src_dir} ${proto_idl_dir} ${thrift_idl_dir}"
inc_dir="${inc_dir} ${src_dir}"

# check dir existance
not_found=
for i in `echo "${inc_dir}"`; do
  if [ -d "${i}" ]; then
    continue
  fi
  echo "dir not found: ${i} "
  not_found="${not_found} ${i}"
done
if [ "x${not_found}" != "x" ]; then
  not_found=${not_found:1}
  echo "error, not found: ${not_found}"
  exit -1
fi

cmake_list=CMakeLists.txt

echo 'cmake_minimum_required(VERSION 3.7)'>${cmake_list}
echo "project(${project})">>${cmake_list}
echo 'set(CMAKE_CXX_STANDARD 17)'>>${cmake_list}

for i in ${inc_dir}; do
  echo "include_directories(${i})">>${cmake_list}
done

echo 'set(SOURCE_FILES'>>${cmake_list}

# all sources
# gen protobuf/thrift .h and .cpp
if [ -x "$(command -v protoc)" ]; then
  for i in ${proto_idl_dir}; do
    if [ ! -d "${i}" ]; then continue; fi
    find ${i} -type f -iname '*.proto' | xargs -I% protoc --cpp_out `dirname ${i}` %
  done
elif [ "x${proto_idl_dir}" != "x" ]; then
  echo "waning: protoc not found, proto files will not compile"
fi
if [ -x "$(command -v thrift)" ]; then
  for i in ${thrift_idl_dir}; do
    find ${i} -type f -iname '*.thrift' | xargs -I% thrift -o `dirname ${i}` --gen cpp %
  done
elif [ "x${thrift_idl_dir}" != "x" ]; then
  echo "waning: thrift not found, thrift files will not compile"
fi
# src
for i in ${src_dir}; do
  if [ ! -d "${i}" ]; then continue; fi
  find ${i} -type f | grep -E '(\.cpp$)|(\.cc$)|(\.c\+\+$)|(\.c$)'>>${cmake_list}
done

echo ')'>>${cmake_list}
echo "add_executable(${project}"' ${SOURCE_FILES})'>>${cmake_list}

# vim: et tw=80 ts=2 sw=2 cc=80:
