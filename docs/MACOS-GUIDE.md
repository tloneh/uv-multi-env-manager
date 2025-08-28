# 🍎 macOS 使用指南

UV Multi-Environment Manager 在 macOS 上的完整使用指南。

## 📋 系统要求

- **macOS版本**: macOS 10.15 (Catalina) 或更高版本
- **芯片支持**: Intel x86_64 和 Apple Silicon (M1/M2/M3)
- **Shell**: zsh (默认) 或 bash
- **Python**: 3.11+ (推荐使用Homebrew安装)

## 🚀 快速安装

### 1. 安装前置依赖

```bash
# 安装Homebrew（如果没有）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 安装Python（推荐）
brew install python@3.12 python@3.11

# 安装UV
brew install uv
# 或使用官方脚本
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### 2. 获取工具

```bash
# 克隆项目
git clone https://github.com/YOUR-USERNAME/YOUR-REPO.git
cd uv-multi-env-manager

# 设置权限
chmod +x *.sh

# 快速测试
./example.sh
```

## 🔧 macOS 特定配置

### Shell 配置

#### Zsh 配置 (macOS 默认)
```bash
# 编辑 ~/.zshrc
nano ~/.zshrc

# 添加以下内容
export PATH="/opt/homebrew/bin:$PATH"  # Apple Silicon
# export PATH="/usr/local/bin:$PATH"   # Intel Mac

# 加载UV环境管理别名
source ~/path/to/uv-multi-env-manager/uv-aliases.sh

# 重新加载配置
source ~/.zshrc
```

#### Bash 配置
```bash
# 编辑 ~/.bash_profile 或 ~/.bashrc
nano ~/.bash_profile

# 添加相同内容
export PATH="/opt/homebrew/bin:$PATH"
source ~/path/to/uv-multi-env-manager/uv-aliases.sh

# 重新加载
source ~/.bash_profile
```

### Python 版本管理

#### 使用 Homebrew Python
```bash
# 查看已安装的Python版本
brew list | grep python

# 创建环境时指定版本
uv-create myproject python3.12
uv-create legacy python3.11

# 查看可用Python版本
ls /opt/homebrew/bin/python*  # Apple Silicon
ls /usr/local/bin/python*     # Intel Mac
```

#### 使用 pyenv (可选)
```bash
# 安装pyenv
brew install pyenv

# 安装Python版本
pyenv install 3.12.0
pyenv install 3.11.0

# 设置全局版本
pyenv global 3.12.0

# 在环境创建时使用
uv-create myproject $(pyenv which python3.12)
```

## 🛠️ 使用方法

### 基本操作
```bash
# 加载别名
source uv-aliases.sh

# 创建环境
uv-create myproject python3.12

# 列出环境
uv-list

# 切换环境
uv-switch myproject
source activate-myproject.sh

# 安装包
uv-install myproject numpy pandas matplotlib

# 运行脚本
uv-run myproject python script.py
```

### 项目级环境管理
```bash
# 使用Makefile
make dev      # 创建开发环境
make test     # 创建测试环境
make prod     # 创建生产环境

# 快速切换
uv-dev        # 切换到开发环境
uv-test       # 切换到测试环境
```

## 🍎 macOS 特殊功能

### 1. Finder 集成
创建Finder快捷方式：

```bash
# 创建应用程序脚本
cat > ~/Applications/UV-Manager.app/Contents/MacOS/UV-Manager << 'EOF'
#!/bin/bash
cd ~/path/to/uv-multi-env-manager
open -a Terminal.app .
EOF

chmod +x ~/Applications/UV-Manager.app/Contents/MacOS/UV-Manager
```

### 2. 通知中心集成
```bash
# 在脚本中添加通知
show_notification() {
    local title="$1"
    local message="$2"
    osascript -e "display notification \"$message\" with title \"$title\""
}

# 使用示例
show_notification "UV Manager" "环境 myproject 创建成功"
```

### 3. Spotlight 搜索集成
```bash
# 创建可搜索的脚本
sudo ln -s ~/path/to/uv-multi-env-manager/uv-env-manager.sh /usr/local/bin/uv-manager
```

## 🔍 故障排除

### 常见问题

#### 1. 权限问题
```bash
# 修复权限
chmod +x *.sh
sudo chown -R $(whoami) ~/.uv-envs
```

#### 2. PATH 问题
```bash
# 检查PATH
echo $PATH

# 添加Homebrew路径
export PATH="/opt/homebrew/bin:$PATH"  # Apple Silicon
export PATH="/usr/local/bin:$PATH"     # Intel Mac
```

#### 3. Python 版本问题
```bash
# 检查Python安装
which python3
python3 --version

# 重新安装Python
brew reinstall python@3.12
```

#### 4. UV 安装问题
```bash
# 重新安装UV
brew uninstall uv
brew install uv

# 或使用官方脚本
curl -LsSf https://astral.sh/uv/install.sh | sh
```

#### 5. Xcode 命令行工具
```bash
# 安装Xcode命令行工具
xcode-select --install

# 检查安装
xcode-select -p
```

### 性能优化

#### 1. SSD 优化
```bash
# 将环境存储在SSD上
export VENV_BASE_DIR="/Users/$(whoami)/.uv-envs"
```

#### 2. 内存优化
```bash
# 增加UV缓存大小
export UV_CACHE_DIR="/Users/$(whoami)/.cache/uv"
```

## 🧪 测试和验证

### 系统兼容性测试
```bash
#!/bin/bash
# test-macos.sh

echo "=== macOS 兼容性测试 ==="
echo "系统版本: $(sw_vers -productVersion)"
echo "芯片架构: $(uname -m)"
echo "Shell: $SHELL"
echo "Python: $(python3 --version)"
echo "UV: $(uv --version)"
echo "Homebrew: $(brew --version | head -1)"

# 测试环境创建
echo "测试环境创建..."
./uv-env-manager.sh create test-macos python3.12

# 测试包安装
echo "测试包安装..."
./uv-env-manager.sh install test-macos requests

# 测试环境激活
echo "测试环境激活..."
./uv-env-manager.sh activate test-macos
source activate-test-macos.sh
python -c "import requests; print('✅ 包导入成功')"
deactivate

# 清理
./uv-env-manager.sh remove test-macos

echo "✅ macOS 兼容性测试完成"
```

### 性能基准测试
```bash
#!/bin/bash
# benchmark-macos.sh

echo "=== macOS 性能基准测试 ==="

# 测试环境创建速度
time ./uv-env-manager.sh create benchmark-test python3.12

# 测试包安装速度
time ./uv-env-manager.sh install benchmark-test numpy pandas matplotlib

# 测试环境切换速度
time ./uv-env-manager.sh activate benchmark-test

# 清理
./uv-env-manager.sh remove benchmark-test

echo "✅ 性能测试完成"
```

## 🔧 高级配置

### 1. 自定义环境路径
```bash
# 在 ~/.zshrc 中设置
export VENV_BASE_DIR="/Users/$(whoami)/Development/envs"
export UV_CACHE_DIR="/Users/$(whoami)/.cache/uv"
```

### 2. 集成开发环境
```bash
# VS Code 集成
code --install-extension ms-python.python
code --install-extension ms-python.vscode-pylance

# PyCharm 集成
# 在 PyCharm 中设置解释器路径为: ~/.uv-envs/myproject/bin/python
```

### 3. 自动化脚本
```bash
# 创建项目初始化脚本
create_project() {
    local project_name="$1"
    mkdir "$project_name"
    cd "$project_name"
    
    # 创建环境
    uv-create "$project_name" python3.12
    
    # 创建基本文件
    touch README.md requirements.txt
    echo "print('Hello, $project_name!')" > main.py
    
    # 激活环境
    uv-switch "$project_name"
    source "activate-$project_name.sh"
    
    echo "✅ 项目 $project_name 创建完成"
}
```

## 📱 移动开发集成

### iOS 开发
```bash
# 安装iOS开发相关包
uv-install ios-project kivy-ios cython

# 构建iOS应用
uv-run ios-project python setup.py build_ios
```

### 跨平台开发
```bash
# 安装跨平台框架
uv-install cross-platform kivy pygame

# 测试跨平台兼容性
uv-run cross-platform python test_compatibility.py
```

## 🎯 最佳实践

### 1. 项目组织
```
~/Development/
├── Projects/
│   ├── project1/
│   │   ├── .venv-dev/
│   │   └── src/
│   └── project2/
└── Tools/
    └── uv-multi-env-manager/
```

### 2. 环境命名
```bash
# 使用描述性名称
uv-create myapp-dev python3.12
uv-create myapp-test python3.12
uv-create myapp-prod python3.11
```

### 3. 依赖管理
```bash
# 导出依赖
uv-run myproject pip freeze > requirements.txt

# 安装依赖
uv-install myproject -r requirements.txt
```

---

🍎 **在 macOS 上享受高效的 Python 环境管理！**
