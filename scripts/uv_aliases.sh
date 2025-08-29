#!/bin/bash

# UV 环境管理别名配置
# 使用方法: source uv_aliases.sh

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}正在加载 UV 环境管理别名...${NC}"

# 工具目录配置
# 自动检测脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# 项目根目录
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# 环境管理器别名
alias uv-create="$SCRIPT_DIR/uv_env_manager.sh create"
alias uv-list="$SCRIPT_DIR/uv_env_manager.sh list"
alias uv-remove="$SCRIPT_DIR/uv_env_manager.sh remove"
alias uv-info="$SCRIPT_DIR/uv_env_manager.sh info"
alias uv-install="$SCRIPT_DIR/uv_env_manager.sh install"
alias uv-run="$SCRIPT_DIR/uv_env_manager.sh run"
alias uv-switch="$SCRIPT_DIR/uv_env_manager.sh switch"
alias uv-current="$SCRIPT_DIR/uv_env_manager.sh current"

# 快速环境切换别名
alias uv-dev="source $SCRIPT_DIR/uv_switch.sh dev"
alias uv-test="source $SCRIPT_DIR/uv_switch.sh test"
alias uv-prod="source $SCRIPT_DIR/uv_switch.sh prod"
alias uv-exp="source $SCRIPT_DIR/uv_switch.sh exp"

# Make 命令别名
alias uv-make-dev="make -C $PROJECT_DIR dev"
alias uv-make-test="make -C $PROJECT_DIR test"
alias uv-make-prod="make -C $PROJECT_DIR prod"
alias uv-make-list="make -C $PROJECT_DIR list"
alias uv-make-info="make -C $PROJECT_DIR info"
alias uv-make-clean="make -C $PROJECT_DIR clean-all"

# 便捷函数
uv-help() {
    echo -e "${BLUE}UV 环境管理别名帮助${NC}"
    echo ""
    echo "环境管理:"
    echo "  uv-create <name> [python]  - 创建新环境"
    echo "  uv-list                    - 列出所有环境"
    echo "  uv-remove <name>           - 删除环境"
    echo "  uv-info <name>             - 显示环境信息"
    echo "  uv-install <name> <pkg>    - 安装包到环境"
    echo "  uv-run <name> <cmd>        - 在环境中运行命令"
    echo "  uv-switch <name>           - 切换到环境"
    echo "  uv-current                 - 显示当前环境"
    echo ""
    echo "快速切换:"
    echo "  uv-dev                     - 切换到开发环境"
    echo "  uv-test                    - 切换到测试环境"
    echo "  uv-prod                    - 切换到生产环境"
    echo "  uv-exp                     - 切换到实验环境"
    echo ""
    echo "Make 命令:"
    echo "  uv-make-dev                - 创建开发环境"
    echo "  uv-make-test               - 创建测试环境"
    echo "  uv-make-prod               - 创建生产环境"
    echo "  uv-make-list               - 列出项目环境"
    echo "  uv-make-info               - 显示项目环境信息"
    echo "  uv-make-clean              - 清理所有项目环境"
    echo ""
    echo "其他:"
    echo "  uv-help                    - 显示此帮助信息"
    echo "  uv-status                  - 显示环境状态"
}

# 状态显示函数
uv-status() {
    echo -e "${BLUE}UV 环境状态概览${NC}"
    echo ""
    echo "全局环境:"
    $SCRIPT_DIR/uv_env_manager.sh list
    echo ""
    echo "项目环境:"
    make -C $PROJECT_DIR list
    echo ""
    if [ -n "$VIRTUAL_ENV" ]; then
        echo -e "${GREEN}当前激活环境: $(basename $VIRTUAL_ENV)${NC}"
        echo "路径: $VIRTUAL_ENV"
    else
        echo "当前没有激活的环境"
    fi
}

echo -e "${GREEN}✓ UV 环境管理别名已加载${NC}"
echo -e "使用 ${BLUE}uv-help${NC} 查看可用命令"
