#!/bin/bash

# UV Multi-Environment Manager 使用示例
# 这个脚本演示了如何使用工具的基本功能

set -e

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}=== UV Multi-Environment Manager 使用示例 ===${NC}"
echo ""

# 目录配置
EXAMPLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$EXAMPLE_DIR")"
SCRIPT_DIR="$PROJECT_DIR/scripts"

# 检查工具是否可用
if [ ! -f "$SCRIPT_DIR/uv-env-manager.sh" ]; then
    echo -e "${YELLOW}错误: 找不到 uv-env-manager.sh 文件${NC}"
    echo -e "请确保在正确的目录中运行此脚本，或检查文件是否存在"
    exit 1
fi

echo -e "${GREEN}1. 加载别名${NC}"
echo "source $SCRIPT_DIR/uv-aliases.sh"
source "$SCRIPT_DIR/uv-aliases.sh"
echo ""

echo -e "${GREEN}2. 查看帮助信息${NC}"
echo "uv-help"
uv-help
echo ""

echo -e "${GREEN}3. 创建示例环境${NC}"
echo "uv-create demo-env python3.12"
"$SCRIPT_DIR/uv-env-manager.sh" create demo-env python3.12
echo ""

echo -e "${GREEN}4. 列出所有环境${NC}"
echo "uv-list"
"$SCRIPT_DIR/uv-env-manager.sh" list
echo ""

echo -e "${GREEN}5. 在环境中安装包${NC}"
echo "uv-install demo-env numpy"
"$SCRIPT_DIR/uv-env-manager.sh" install demo-env numpy
echo ""

echo -e "${GREEN}6. 在环境中运行命令${NC}"
echo "uv-run demo-env python -c \"import numpy; print('NumPy version:', numpy.__version__)\""
"$SCRIPT_DIR/uv-env-manager.sh" run demo-env python -c "import numpy; print('NumPy version:', numpy.__version__)"
echo ""

echo -e "${GREEN}7. 查看环境信息${NC}"
echo "uv-info demo-env"
"$SCRIPT_DIR/uv-env-manager.sh" info demo-env
echo ""

echo -e "${GREEN}8. 使用 Makefile 创建项目环境${NC}"
echo "make -C $PROJECT_DIR dev"
make -C "$PROJECT_DIR" dev
echo ""

echo -e "${GREEN}9. 查看项目环境状态${NC}"
echo "make -C $PROJECT_DIR list"
make -C "$PROJECT_DIR" list
echo ""

echo -e "${GREEN}10. 清理示例环境${NC}"
echo "uv-remove demo-env"
read -p "是否删除示例环境 demo-env? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    "$SCRIPT_DIR/uv-env-manager.sh" remove demo-env
fi
echo ""

echo -e "${BLUE}=== 示例完成 ===${NC}"
echo ""
echo -e "${YELLOW}提示:${NC}"
echo "- 使用 'uv-help' 查看所有可用命令"
echo "- 使用 'make help' 查看 Makefile 命令"
echo "- 查看 README.md 了解详细使用方法"
echo "- 查看 INSTALLATION.md 了解配置方法"
