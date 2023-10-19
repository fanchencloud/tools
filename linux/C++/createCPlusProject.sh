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

# 添加可执行文件
add_executable($project_name \${CMAKE_SOURCE_DIR}/src/main.cpp)

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
