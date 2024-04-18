#!/bin/bash

# 询问用户项目名称
read -p "请输入项目名称(按回车键使用默认名称 'my_cpp_project'): " project_name
project_name=${project_name:-my_cpp_project}

# 检查是否存在同名文件夹
index=1
while [ -d "$project_name" ]; do
    project_name="${project_name}_${index}"
    ((index++))
done

# 创建工程目录
mkdir "$project_name"
cd "$project_name"

# 创建 src, include 和 test 目录
mkdir src include test doc
# 创建README.md文件
touch README.md

# 创建 CMakeLists.txt 文件
cat <<EOL > CMakeLists.txt
cmake_minimum_required(VERSION 3.0)
project($project_name)

# 设置构建目录
set(CMAKE_BINARY_DIR \${CMAKE_SOURCE_DIR}/build)

# 创建构建目录
file(MAKE_DIRECTORY \${CMAKE_BINARY_DIR})

# 设置C++标准
set(CMAKE_CXX_STANDARD 11)

# 设置src目录的路径
set(SRC_DIR \${CMAKE_SOURCE_DIR}/src)

# 递归查找src目录下的所有子目录
file(GLOB_RECURSE SUBDIRECTORIES LIST_DIRECTORIES true "\${SRC_DIR}/*")

# 遍历所有子目录，获取其中的文件路径
foreach(SUBDIRECTORY IN LISTS SUBDIRECTORIES)
    file(GLOB_RECURSE FILES_IN_SUBDIR "\${SUBDIRECTORY}/*")
    list(APPEND ALL_FILES \${FILES_IN_SUBDIR})
endforeach()

# 打印所有文件的路径（可选）
foreach(FILE_PATH IN LISTS ALL_FILES)
    message(STATUS "Found file: \${FILE_PATH}")
endforeach()

# 添加可执行文件
add_executable($project_name \${CMAKE_SOURCE_DIR}/src/main.cpp \${ALL_FILES})

# 如果有头文件，将它们添加到包含路径
target_include_directories($project_name PRIVATE include)

# 设置输出目录
set(EXECUTABLE_OUTPUT_PATH \${CMAKE_BINARY_DIR}/bin)
# 创建输出目录
file(MAKE_DIRECTORY \${EXECUTABLE_OUTPUT_PATH})

# 将可执行文件复制到 bin 目录
add_custom_command(TARGET $project_name POST_BUILD
    COMMAND \${CMAKE_COMMAND} -E copy $<TARGET_FILE:$project_name> \${EXECUTABLE_OUTPUT_PATH}
)
# 编译器选项
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Werror")

# 添加删除Cmake生成的临时文件
add_custom_target(clean_all
    # 删除build目录
    COMMAND \${CMAKE_COMMAND} -E remove_directory \${CMAKE_BINARY_DIR}
    # 删除CMakeFiles目录
    COMMAND \${CMAKE_COMMAND} -E remove_directory CMakeFiles
    # 删除生成Makefile
    COMMAND \${CMAKE_COMMAND} -E remove Makefile
    # 删除cmakecache.txt
    COMMAND \${CMAKE_COMMAND} -E remove cmakecache.txt CMakeCache.txt
    # 删除cmake_install.cmake
    COMMAND \${CMAKE_COMMAND} -E remove cmake_install.cmake
    # 删除install_manifest.txt
    COMMAND \${CMAKE_COMMAND} -E remove install_manifest.txt
)

# 添加自定义目标来运行可执行文件
add_custom_target(run
    COMMAND $project_name
    DEPENDS $project_name
    WORKING_DIRECTORY ${CMAKE_PROJECT_DIR}
)
EOL

# 创建示例的 main.cpp 文件
echo -e "#include <iostream>

int main()
{
    std::cout << \"Hello, C++ World!\" << std::endl;
    return 0;
}" > src/main.cpp

# 提示用户
echo "C++工程 '$project_name' 已创建。"
