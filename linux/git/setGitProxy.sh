#!/bin/bash

# 定义颜色
RESET='\033[0m'     # 重置颜色
RED='\033[0;31m'    # 红色
GREEN='\033[0;32m'  # 绿色

# 高亮版本
BRIGHT_BLUE='\033[1;34m'   # 高亮蓝色
BRIGHT_PURPLE='\033[1;35m' # 高亮紫色

# 定义一个显示菜单的函数
function display_menu {
    echo ""
    echo "请选择操作:"
    echo -e "${GREEN}1. 设置Git代理${RESET}"
    echo -e "${BRIGHT_PURPLE}2. 取消Git代理${RESET}"
    echo -e "${BRIGHT_BLUE}3. 查看当前代理情况${RESET}"
    echo -e "按其余键退出"
}

# git config --global https.proxy https://username:password@proxyserver:port
# 设置Git代理的函数
function set_git_proxy {
    read -p "请输入代理地址: " proxy_address
    read -p "请输入代理端口: " proxy_port
    # 简单的输入校验
    if [[ ! $proxy_address =~ ^[a-zA-Z0-9:.]+$ ]] || [[ ! $proxy_port =~ ^[0-9]{1,5}$ ]]; then
        echo -e "${RED}输入的代理地址或端口不合法，请重新输入。${RESET}"
        return 1
    fi

    # 选择代理的协议：http或者socks
    read -p "$(echo -e "请选择代理协议(${GREEN}1.http${RESET} | ${GREEN}2. socks${RESET} | 默认为${GREEN}http${RESET})"): " protocol
    if [ "$protocol" = "2" ]; then
        git config --global http.proxy  socks5://$proxy_address:$proxy_port
        git config --global https.proxy socks5://$proxy_address:$proxy_port
    else
        git config --global http.proxy  http://$proxy_address:$proxy_port
        git config --global https.proxy http://$proxy_address:$proxy_port
    fi

    echo -e "${GREEN}Git代理已设置。${RESET}"
}

# 取消Git代理的函数
function unset_git_proxy {
    git config --global --unset http.proxy
    git config --global --unset https.proxy
    echo "Git代理已取消。"
}

# 查看当前代理情况的函数
function show_git_proxy {
    current_http_proxy=$(git config --global --get http.proxy)
    current_https_proxy=$(git config --global --get https.proxy)

    if [ -n "$current_http_proxy" ]; then
        echo "当前Git HTTP代理: $current_http_proxy"
    else
        echo "当前Git HTTP代理未设置。"
    fi

    if [ -n "$current_https_proxy" ]; then
        echo "当前Git HTTPS代理: $current_https_proxy"
    else
        echo "当前Git HTTPS代理未设置。"
    fi
}

# 主循环
while true; do
    # 显示菜单
    display_menu

    # 读取用户输入
    read -p "请选择操作: " choice

    # 检查用户输入并执行相应操作
    case $choice in
    1)
        if set_git_proxy; then
            # 如果成功，可以添加额外的处理逻辑
            :
        else
            echo -e "${RED}设置Git代理失败，请检查输入。${RESET}"
        fi
        ;;
    2)
        unset_git_proxy
        ;;
    3)
        show_git_proxy
        ;;
    *)
        echo "退出程序."
        break
        ;;
    esac
done
