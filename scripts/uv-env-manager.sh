#!/bin/bash

# UV 虚拟环境管理器
# 使用方法: ./uv-env-manager.sh [command] [env_name] [options]

set -e

# 配置
# TODO: 如果需要自定义虚拟环境存储位置，请修改以下路径
VENV_BASE_DIR="$HOME/.uv-envs"  # 全局虚拟环境的基础目录
TOOL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"  # 工具所在目录
WORK_DIR="$(pwd)"  # 当前工作目录
CONFIG_FILE="$HOME/.uv-env-config"  # 当前环境配置文件

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 帮助信息
show_help() {
    echo -e "${BLUE}UV 虚拟环境管理器${NC}"
    echo ""
    echo "使用方法: $0 [command] [env_name] [options]"
    echo ""
    echo "命令:"
    echo "  create <env_name> [python_version]  - 创建新的虚拟环境"
    echo "  list                                - 列出所有虚拟环境"
    echo "  activate <env_name>                 - 激活虚拟环境 (生成激活脚本)"
    echo "  remove <env_name>                   - 删除虚拟环境"
    echo "  info <env_name>                     - 显示虚拟环境信息"
    echo "  run <env_name> <command>            - 在指定环境中运行命令"
    echo "  install <env_name> <packages>       - 在指定环境中安装包"
    echo "  current                             - 显示当前激活的环境"
    echo "  switch <env_name>                   - 切换到指定环境"
    echo ""
    echo "示例:"
    echo "  $0 create myproject python3.12     - 创建使用Python 3.12的环境"
    echo "  $0 list                             - 列出所有环境"
    echo "  $0 run myproject python script.py  - 在myproject环境中运行脚本"
    echo "  $0 install myproject numpy pandas  - 在myproject环境中安装包"
    echo "  $0 switch myproject                 - 切换到myproject环境"
}

# 确保基础目录存在
ensure_base_dir() {
    if [ ! -d "$VENV_BASE_DIR" ]; then
        mkdir -p "$VENV_BASE_DIR"
        echo -e "${GREEN}创建虚拟环境基础目录: $VENV_BASE_DIR${NC}"
    fi
}

# 创建虚拟环境
create_env() {
    local env_name="$1"
    local python_version="${2:-python3.12}"
    
    if [ -z "$env_name" ]; then
        echo -e "${RED}错误: 请提供环境名称${NC}"
        exit 1
    fi
    
    local env_path="$VENV_BASE_DIR/$env_name"
    
    if [ -d "$env_path" ]; then
        echo -e "${YELLOW}警告: 环境 '$env_name' 已存在${NC}"
        read -p "是否覆盖? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 0
        fi
        rm -rf "$env_path"
    fi
    
    echo -e "${BLUE}创建虚拟环境: $env_name (使用 $python_version)${NC}"
    uv venv "$env_path" --python "$python_version"
    
    # 记录环境信息
    echo "$(date): 创建环境 $env_name (Python: $python_version)" >> "$VENV_BASE_DIR/.env_history"
    
    echo -e "${GREEN}✓ 虚拟环境 '$env_name' 创建成功${NC}"
    echo -e "路径: $env_path"
}

# 列出所有虚拟环境
list_envs() {
    ensure_base_dir
    
    echo -e "${BLUE}可用的虚拟环境:${NC}"
    echo ""
    
    if [ ! "$(ls -A $VENV_BASE_DIR 2>/dev/null | grep -v '^\.')" ]; then
        echo -e "${YELLOW}没有找到虚拟环境${NC}"
        return
    fi
    
    local current_env=$(get_current_env)
    
    for env_dir in "$VENV_BASE_DIR"/*; do
        if [ -d "$env_dir" ] && [ "$(basename "$env_dir")" != ".*" ]; then
            local env_name=$(basename "$env_dir")
            local python_version=""
            
            if [ -f "$env_dir/pyvenv.cfg" ]; then
                python_version=$(grep "version" "$env_dir/pyvenv.cfg" | cut -d'=' -f2 | tr -d ' ')
            fi
            
            local marker=""
            if [ "$env_name" = "$current_env" ]; then
                marker=" ${GREEN}(当前)${NC}"
            fi
            
            echo -e "  • ${GREEN}$env_name${NC} - Python $python_version$marker"
            echo -e "    路径: $env_dir"
            echo ""
        fi
    done
}

# 获取当前激活的环境
get_current_env() {
    if [ -f "$CONFIG_FILE" ]; then
        cat "$CONFIG_FILE"
    fi
}

# 设置当前环境
set_current_env() {
    echo "$1" > "$CONFIG_FILE"
}

# 切换环境
switch_env() {
    local env_name="$1"
    
    if [ -z "$env_name" ]; then
        echo -e "${RED}错误: 请提供环境名称${NC}"
        exit 1
    fi
    
    local env_path="$VENV_BASE_DIR/$env_name"
    
    if [ ! -d "$env_path" ]; then
        echo -e "${RED}错误: 环境 '$env_name' 不存在${NC}"
        exit 1
    fi
    
    set_current_env "$env_name"
    echo -e "${GREEN}✓ 已切换到环境: $env_name${NC}"
    
    # 生成激活脚本
    generate_activate_script "$env_name"
}

# 生成激活脚本
generate_activate_script() {
    local env_name="$1"
    local env_path="$VENV_BASE_DIR/$env_name"
    local activate_script="activate-$env_name.sh"
    
    cat > "$activate_script" << EOF
#!/bin/bash
# 激活 $env_name 虚拟环境

export UV_VENV_PATH="$env_path"
export VIRTUAL_ENV="$env_path"
export PATH="$env_path/bin:\$PATH"

# 更新提示符
if [ -z "\$VIRTUAL_ENV_DISABLE_PROMPT" ]; then
    export PS1="($env_name) \$PS1"
fi

echo -e "\033[0;32m✓ 已激活虚拟环境: $env_name\033[0m"
echo -e "路径: $env_path"
echo -e "使用 'deactivate' 命令退出虚拟环境"

# 定义 deactivate 函数
deactivate() {
    if [ -n "\$_OLD_VIRTUAL_PATH" ]; then
        PATH="\$_OLD_VIRTUAL_PATH"
        export PATH
        unset _OLD_VIRTUAL_PATH
    fi
    
    if [ -n "\$_OLD_VIRTUAL_PS1" ]; then
        PS1="\$_OLD_VIRTUAL_PS1"
        export PS1
        unset _OLD_VIRTUAL_PS1
    fi
    
    unset VIRTUAL_ENV
    unset UV_VENV_PATH
    unset -f deactivate
    
    echo -e "\033[0;33m已退出虚拟环境\033[0m"
}

# 保存原始环境变量
export _OLD_VIRTUAL_PATH="\$PATH"
export _OLD_VIRTUAL_PS1="\$PS1"
EOF
    
    chmod +x "$activate_script"
    echo -e "${BLUE}激活脚本已生成: $activate_script${NC}"
    echo -e "运行 ${YELLOW}source $activate_script${NC} 来激活环境"
}

# 在指定环境中运行命令
run_in_env() {
    local env_name="$1"
    shift
    local command="$@"
    
    if [ -z "$env_name" ]; then
        echo -e "${RED}错误: 请提供环境名称${NC}"
        exit 1
    fi
    
    local env_path="$VENV_BASE_DIR/$env_name"
    
    if [ ! -d "$env_path" ]; then
        echo -e "${RED}错误: 环境 '$env_name' 不存在${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}在环境 '$env_name' 中运行: $command${NC}"
    
    # 如果存在 .env 文件，加载它
    if [ -f ".env" ]; then
        set -a
        source .env
        set +a
    fi
    
    # 使用 VIRTUAL_ENV 环境变量运行命令，避免 eval 的引号问题
    VIRTUAL_ENV="$env_path" PATH="$env_path/bin:$PATH" "$@"
}

# 在指定环境中安装包
install_in_env() {
    local env_name="$1"
    shift
    local packages="$@"
    
    if [ -z "$env_name" ]; then
        echo -e "${RED}错误: 请提供环境名称${NC}"
        exit 1
    fi
    
    if [ -z "$packages" ]; then
        echo -e "${RED}错误: 请提供要安装的包名${NC}"
        exit 1
    fi
    
    local env_path="$VENV_BASE_DIR/$env_name"
    
    if [ ! -d "$env_path" ]; then
        echo -e "${RED}错误: 环境 '$env_name' 不存在${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}在环境 '$env_name' 中安装包: $packages${NC}"
    
    # 使用 uv pip 安装包
    VIRTUAL_ENV="$env_path" uv pip install $packages
    
    echo -e "${GREEN}✓ 包安装完成${NC}"
}

# 删除虚拟环境
remove_env() {
    local env_name="$1"
    
    if [ -z "$env_name" ]; then
        echo -e "${RED}错误: 请提供环境名称${NC}"
        exit 1
    fi
    
    local env_path="$VENV_BASE_DIR/$env_name"
    
    if [ ! -d "$env_path" ]; then
        echo -e "${RED}错误: 环境 '$env_name' 不存在${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}警告: 即将删除环境 '$env_name'${NC}"
    echo -e "路径: $env_path"
    read -p "确认删除? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$env_path"
        
        # 如果是当前环境，清除配置
        local current_env=$(get_current_env)
        if [ "$env_name" = "$current_env" ]; then
            rm -f "$CONFIG_FILE"
        fi
        
        # 删除激活脚本
        rm -f "activate-$env_name.sh"
        
        echo -e "${GREEN}✓ 环境 '$env_name' 已删除${NC}"
    else
        echo -e "${BLUE}取消删除${NC}"
    fi
}

# 显示环境信息
show_env_info() {
    local env_name="$1"
    
    if [ -z "$env_name" ]; then
        echo -e "${RED}错误: 请提供环境名称${NC}"
        exit 1
    fi
    
    local env_path="$VENV_BASE_DIR/$env_name"
    
    if [ ! -d "$env_path" ]; then
        echo -e "${RED}错误: 环境 '$env_name' 不存在${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}环境信息: $env_name${NC}"
    echo -e "路径: $env_path"
    
    if [ -f "$env_path/pyvenv.cfg" ]; then
        echo -e "\n配置信息:"
        cat "$env_path/pyvenv.cfg"
    fi
    
    echo -e "\n已安装的包:"
    VIRTUAL_ENV="$env_path" uv pip list 2>/dev/null || echo "无法获取包列表"
}

# 显示当前环境
show_current() {
    local current_env=$(get_current_env)
    
    if [ -z "$current_env" ]; then
        echo -e "${YELLOW}当前没有激活的环境${NC}"
    else
        echo -e "${GREEN}当前环境: $current_env${NC}"
        echo -e "路径: $VENV_BASE_DIR/$current_env"
    fi
}

# 主函数
main() {
    ensure_base_dir
    
    case "${1:-help}" in
        "create")
            create_env "$2" "$3"
            ;;
        "list")
            list_envs
            ;;
        "activate")
            switch_env "$2"
            ;;
        "switch")
            switch_env "$2"
            ;;
        "remove"|"rm")
            remove_env "$2"
            ;;
        "info")
            show_env_info "$2"
            ;;
        "run")
            run_in_env "$2" "${@:3}"
            ;;
        "install")
            install_in_env "$2" "${@:3}"
            ;;
        "current")
            show_current
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            echo -e "${RED}错误: 未知命令 '$1'${NC}"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# 运行主函数
main "$@"
