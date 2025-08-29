# 🌍 跨平台支持指南

UV Multi-Environment Manager 现在支持多个操作系统平台！

## 📋 平台支持概览

| 平台 | 支持状态 | 主要工具 | 说明 |
|------|----------|----------|------|
| 🐧 **Linux** | ✅ 完全支持 | Bash脚本 | 原生支持，所有功能可用 |
| 🍎 **macOS** | ✅ 完全支持 | Bash脚本 | 与Linux相同，完全兼容 |
| 🪟 **Windows** | ✅ 支持 | PowerShell + WSL | PowerShell脚本 + WSL选项 |

## 🐧 Linux 支持

**状态**: ✅ 完全支持（原生设计）

### 安装和使用
```bash
# 标准安装流程
cd uv-multi-env-manager
chmod +x *.sh
source uv-aliases.sh

# 所有功能都可用
uv-create myproject python3.12
uv-list
uv-dev
```

### 特性
- ✅ 所有Bash脚本功能
- ✅ Makefile自动化
- ✅ 别名系统
- ✅ 环境变量自动加载
- ✅ 跨目录兼容性

## 🍎 macOS 支持

**状态**: ✅ 完全支持

### 前置要求
```bash
# 安装Homebrew（如果没有）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 安装UV
curl -LsSf https://astral.sh/uv/install.sh | sh
# 或使用Homebrew
brew install uv
```

### 安装和使用
```bash
# 与Linux完全相同
cd uv-multi-env-manager
chmod +x *.sh
source uv-aliases.sh

# 所有功能都可用
uv-create myproject python3.12
make dev
uv-status
```

### macOS特殊注意事项
- ✅ 支持Apple Silicon (M1/M2) 和Intel芯片
- ✅ 兼容zsh（macOS默认shell）和bash
- ✅ 支持Homebrew安装的Python版本
- ⚠️ 确保使用最新版本的UV

### 路径配置
```bash
# macOS默认路径
VENV_BASE_DIR="$HOME/.uv-envs"  # 与Linux相同
CONFIG_FILE="$HOME/.uv-env-config"
```

## 🪟 Windows 支持

**状态**: ✅ 支持（PowerShell + WSL选项）

### 方案一：PowerShell 原生支持（推荐）

#### 前置要求
```powershell
# 安装UV（PowerShell管理员模式）
irm https://astral.sh/uv/install.ps1 | iex

# 或使用Scoop
scoop install uv

# 或使用pip
pip install uv
```

#### 使用PowerShell版本
```powershell
# 使用PowerShell脚本
.\uv-env-manager.ps1 create myproject python3.12
.\uv-env-manager.ps1 list
.\uv-env-manager.ps1 install myproject numpy pandas

# 激活环境
.\uv-env-manager.ps1 activate myproject
. .\activate-myproject.ps1
```

#### PowerShell别名设置
创建PowerShell配置文件：
```powershell
# 创建或编辑PowerShell配置文件
notepad $PROFILE

# 添加以下内容到配置文件
$UVToolDir = "C:\path\to\uv-multi-env-manager"

function uv-create { & "$UVToolDir\uv-env-manager.ps1" create @args }
function uv-list { & "$UVToolDir\uv-env-manager.ps1" list @args }
function uv-remove { & "$UVToolDir\uv-env-manager.ps1" remove @args }
function uv-install { & "$UVToolDir\uv-env-manager.ps1" install @args }
function uv-run { & "$UVToolDir\uv-env-manager.ps1" run @args }

Write-Host "UV 环境管理别名已加载" -ForegroundColor Green
```

### 方案二：WSL (Windows Subsystem for Linux)

#### 安装WSL
```powershell
# PowerShell管理员模式
wsl --install

# 安装Ubuntu（推荐）
wsl --install -d Ubuntu
```

#### 在WSL中使用
```bash
# 在WSL Ubuntu中
cd /mnt/c/path/to/uv-multi-env-manager
chmod +x *.sh
source uv-aliases.sh

# 完全Linux体验
uv-create myproject python3.12
make dev
```

### 方案三：Git Bash

#### 使用Git Bash
```bash
# 在Git Bash中
cd /c/path/to/uv-multi-env-manager
chmod +x *.sh
source uv-aliases.sh

# 大部分功能可用
uv-create myproject python3.12
```

## 🔧 跨平台配置

### 自动平台检测
工具会自动检测运行平台并调整行为：

```bash
# 在脚本中添加平台检测
detect_platform() {
    case "$(uname -s)" in
        Linux*)     PLATFORM=Linux;;
        Darwin*)    PLATFORM=Mac;;
        CYGWIN*)    PLATFORM=Cygwin;;
        MINGW*)     PLATFORM=MinGw;;
        MSYS*)      PLATFORM=Msys;;
        *)          PLATFORM="UNKNOWN:$(uname -s)"
    esac
    echo "检测到平台: $PLATFORM"
}
```

### 路径处理
```bash
# 跨平台路径处理
get_home_dir() {
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        echo "$USERPROFILE"
    else
        echo "$HOME"
    fi
}
```

## 📦 平台特定的安装包

### Linux包管理器
```bash
# Ubuntu/Debian
sudo apt update && sudo apt install python3-pip
pip install uv

# CentOS/RHEL/Fedora
sudo dnf install python3-pip
pip install uv

# Arch Linux
sudo pacman -S python-pip
pip install uv
```

### macOS包管理器
```bash
# Homebrew（推荐）
brew install uv

# MacPorts
sudo port install py311-uv

# 直接安装
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### Windows包管理器
```powershell
# Scoop（推荐）
scoop install uv

# Chocolatey
choco install uv

# 直接安装
irm https://astral.sh/uv/install.ps1 | iex
```

## 🧪 平台测试

### 测试脚本
创建跨平台测试：

```bash
#!/bin/bash
# test-platform.sh

echo "=== 跨平台兼容性测试 ==="
echo "平台: $(uname -s)"
echo "Shell: $SHELL"
echo "Python: $(python3 --version 2>/dev/null || python --version)"
echo "UV: $(uv --version)"

# 测试基本功能
echo "测试环境创建..."
./uv-env-manager.sh create test-platform python3.12

echo "测试环境列表..."
./uv-env-manager.sh list

echo "测试包安装..."
./uv-env-manager.sh install test-platform requests

echo "测试环境删除..."
./uv-env-manager.sh remove test-platform

echo "✅ 跨平台测试完成"
```

## 🐛 平台特定问题解决

### Linux问题
```bash
# 权限问题
chmod +x *.sh

# Python版本问题
sudo apt install python3.12-dev
```

### macOS问题
```bash
# Xcode命令行工具
xcode-select --install

# Python路径问题
export PATH="/usr/local/bin:$PATH"
```

### Windows问题
```powershell
# 执行策略问题
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 路径问题
$env:PATH += ";C:\Users\$env:USERNAME\.local\bin"
```

## 📚 平台特定文档

- 📖 [Linux详细指南](README.md) - 主要文档
- 🍎 [macOS使用指南](MACOS-GUIDE.md) - macOS特定说明
- 🪟 [Windows使用指南](WINDOWS-GUIDE.md) - Windows详细配置

## 🎯 推荐使用方案

### 开发者推荐
- **Linux开发者**: 使用原生Bash脚本 ⭐⭐⭐⭐⭐
- **macOS开发者**: 使用原生Bash脚本 ⭐⭐⭐⭐⭐
- **Windows开发者**: 
  - PowerShell原生 ⭐⭐⭐⭐
  - WSL Ubuntu ⭐⭐⭐⭐⭐
  - Git Bash ⭐⭐⭐

### 团队协作推荐
- **混合平台团队**: 统一使用WSL或Docker
- **Windows主导团队**: PowerShell版本
- **Unix主导团队**: 原生Bash脚本

## 🚀 快速开始（各平台）

### Linux/macOS
```bash
git clone https://github.com/tloneh/uv_multi_env_manager.git
cd uv-multi-env-manager
chmod +x *.sh
./example.sh
```

### Windows PowerShell
```powershell
git clone https://github.com/tloneh/uv_multi_env_manager.git
cd uv_multi_env_manager
.\scripts\uv-env-manager.ps1 create myproject python3.12
```

### Windows WSL
```bash
git clone https://github.com/tloneh/uv_multi_env_manager.git
cd uv_multi_env_manager
chmod +x scripts/*.sh
./examples/example.sh
```

---

🌍 **现在您可以在任何平台上使用UV Multi-Environment Manager！**
