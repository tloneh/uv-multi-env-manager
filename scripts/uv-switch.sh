#!/bin/bash

# 快速环境切换脚本
# 使用方法: source uv-switch.sh [env_name]

# 目录配置
TOOL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"  # 工具所在目录
WORK_DIR="$(pwd)"  # 当前工作目录

# 环境配置
declare -A ENVIRONMENTS=(
    ["dev"]=".venv-dev"
    ["test"]=".venv-test" 
    ["prod"]=".venv-prod"
    ["exp"]=".venv-exp"
    ["main"]=".venv"
)

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 显示可用环境
show_environments() {
    echo -e "${BLUE}可用的环境:${NC}"
    for env in "${!ENVIRONMENTS[@]}"; do
        local path="${ENVIRONMENTS[$env]}"
        if [ -d "$path" ]; then
            echo -e "  ${GREEN}✓ $env${NC} -> $path"
        else
            echo -e "  ${YELLOW}✗ $env${NC} -> $path (未创建)"
        fi
    done
}

# 创建环境
create_environment() {
    local env_name="$1"
    local env_path="${ENVIRONMENTS[$env_name]}"
    
    if [ -z "$env_path" ]; then
        echo -e "${RED}错误: 未知环境 '$env_name'${NC}"
        show_environments
        return 1
    fi
    
    if [ -d "$env_path" ]; then
        echo -e "${YELLOW}环境 '$env_name' 已存在${NC}"
        return 0
    fi
    
    echo -e "${BLUE}创建环境: $env_name${NC}"
    
    # 根据环境选择Python版本
    local python_version="python3.12"
    case "$env_name" in
        "prod")
            python_version="python3.11"
            ;;
        "exp")
            python_version="python3.13"
            ;;
    esac
    
    uv venv "$env_path" --python "$python_version"
    echo -e "${GREEN}✓ 环境 '$env_name' 创建成功${NC}"
}

# 激活环境
activate_environment() {
    local env_name="$1"
    
    if [ -z "$env_name" ]; then
        echo -e "${YELLOW}当前可用环境:${NC}"
        show_environments
        return 0
    fi
    
    local env_path="${ENVIRONMENTS[$env_name]}"
    
    if [ -z "$env_path" ]; then
        echo -e "${RED}错误: 未知环境 '$env_name'${NC}"
        show_environments
        return 1
    fi
    
    if [ ! -d "$env_path" ]; then
        echo -e "${YELLOW}环境 '$env_name' 不存在，正在创建...${NC}"
        create_environment "$env_name"
    fi
    
    # 退出当前环境（如果有）
    if [ -n "$VIRTUAL_ENV" ]; then
        deactivate 2>/dev/null || true
    fi
    
    # 激活新环境
    source "$env_path/bin/activate"
    
    # 加载 .env 文件（如果存在）
    if [ -f ".env" ]; then
        set -a
        source .env
        set +a
        echo -e "${BLUE}✓ 已加载 .env 文件${NC}"
    fi
    
    echo -e "${GREEN}✓ 已激活环境: $env_name${NC}"
    echo -e "路径: $(pwd)/$env_path"
    
    # 显示Python版本和已安装包数量
    echo -e "Python版本: $(python --version)"
    local pkg_count=$(pip list --format=freeze | wc -l)
    echo -e "已安装包数量: $pkg_count"
}

# 主函数
if [ "$0" = "${BASH_SOURCE[0]}" ]; then
    echo -e "${RED}错误: 请使用 'source' 命令运行此脚本${NC}"
    echo -e "正确用法: ${YELLOW}source $0 [env_name]${NC}"
    exit 1
fi

# 处理参数
case "${1:-list}" in
    "list"|"ls")
        show_environments
        ;;
    "create")
        if [ -z "$2" ]; then
            echo -e "${RED}错误: 请提供环境名称${NC}"
            show_environments
        else
            create_environment "$2"
        fi
        ;;
    *)
        activate_environment "$1"
        ;;
esac
