# UV Multi-Environment Manager

🚀 一个强大而灵活的 UV 虚拟环境管理工具集，让您轻松管理多个 Python 项目环境。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python](https://img.shields.io/badge/Python-3.11%2B-blue.svg)](https://www.python.org/)
[![UV](https://img.shields.io/badge/UV-Latest-green.svg)](https://github.com/astral-sh/uv)

## 📋 目录

- [特性](#-特性)
- [快速开始](#-快速开始)
- [安装](#-安装)
- [使用方法](#-使用方法)
- [配置](#-配置)
- [扩展开发](#-扩展开发)
- [故障排除](#-故障排除)
- [贡献指南](#-贡献指南)
- [许可证](#-许可证)

## 📚 相关文档

- 📖 [详细配置指南](INSTALLATION.md) - 高级配置和自定义选项
- 🚀 [快速参考](QUICK-REFERENCE.md) - 常用命令速查表
- 🤝 [贡献指南](CONTRIBUTING.md) - 如何参与项目开发
- 📋 [环境管理指南](UV-ENVIRONMENTS-GUIDE.md) - 详细的环境管理说明

## 🌍 平台支持

- 🐧 **Linux** - 完全支持（原生设计）
- 🍎 [macOS 使用指南](MACOS-GUIDE.md) - macOS 特定配置和使用
- 🪟 [Windows 使用指南](WINDOWS-GUIDE.md) - Windows PowerShell + WSL 支持

## ✨ 特性

- 🎯 **多环境支持** - 同时管理开发、测试、生产等多个环境
- 🐍 **多 Python 版本** - 支持 Python 3.11、3.12、3.13 等版本
- 🔄 **快速切换** - 一键切换不同项目环境
- 📦 **依赖管理** - 自动化包安装和依赖管理
- 🎨 **友好界面** - 彩色输出和直观的命令行界面
- ⚡ **高性能** - 基于 UV 的快速包管理
- 🛠️ **可扩展** - 模块化设计，易于定制和扩展

## 🚀 快速开始

```bash
# 1. 进入工具目录
cd uv-multi-env-manager

# 2. 运行使用示例（推荐新用户）
./examples/example.sh

# 或者手动执行：
# 3. 加载别名
source scripts/uv-aliases.sh

# 4. 创建开发环境
uv-make-dev

# 5. 切换到开发环境
uv-dev

# 6. 安装项目依赖
uv pip install -e .
```

## 📦 安装

### 前置要求

- Python 3.11+ (理论流行版本均可，只测试了3.11+)
- [UV](https://github.com/astral-sh/uv) 包管理器
- **Linux/macOS**: Bash shell
- **Windows**: PowerShell 5.1+ 或 WSL2

### 安装 UV

**Linux/macOS:**
```bash
# 使用官方安装脚本
curl -LsSf https://astral.sh/uv/install.sh | sh

# macOS 使用 Homebrew
brew install uv

# 或使用 pip
pip install uv
```

**Windows:**
```powershell
# 使用官方安装脚本
irm https://astral.sh/uv/install.ps1 | iex

# 使用 Scoop
scoop install uv

# 或使用 pip
pip install uv
```

### 获取工具

```bash
# 方法1: 使用现有文件（推荐）
cd uv-multi-env-manager

# 方法2: 如果需要从远程下载（需要修改为实际的仓库地址）
# TODO: 替换为您的实际仓库地址
# wget https://raw.githubusercontent.com/tloneh/uv-multi-env-manager/main/scripts/uv-env-manager.sh
# wget https://raw.githubusercontent.com/tloneh/uv-multi-env-manager/main/scripts/uv-aliases.sh
# wget https://raw.githubusercontent.com/tloneh/uv-multi-env-manager/main/scripts/uv-switch.sh
# wget https://raw.githubusercontent.com/tloneh/uv-multi-env-manager/main/Makefile

# 方法3: 克隆整个仓库（需要修改为实际的仓库地址）
# TODO: 替换为您的实际仓库地址
# git clone https://github.com/tloneh/uv-multi-env-manager.git
# cd uv-multi-env-manager

# 设置执行权限
chmod +x *.sh
```

## 📖 使用方法

### 方式一：别名命令（推荐）

```bash
# 加载别名
source scripts/uv-aliases.sh

# 环境管理
uv-create myproject python3.12    # 创建环境
uv-list                           # 列出所有环境
uv-info myproject                 # 查看环境信息
uv-remove myproject               # 删除环境

# 快速切换
uv-dev                           # 切换到开发环境
uv-test                          # 切换到测试环境
uv-prod                          # 切换到生产环境
uv-exp                           # 切换到实验环境

# 包管理
uv-install myproject numpy pandas # 安装包
uv-run myproject python script.py # 运行脚本

# 状态查看
uv-status                        # 查看所有环境状态
uv-current                       # 查看当前环境
uv-help                          # 显示帮助信息
```

### 方式二：Makefile 自动化

```bash
# 环境创建
make dev                         # 创建开发环境 (Python 3.12)
make test                        # 创建测试环境 (Python 3.12)
make prod                        # 创建生产环境 (Python 3.11)
make exp                         # 创建实验环境 (Python 3.13)

# 依赖管理
make install-dev                 # 安装开发依赖
make install-test                # 安装测试依赖
make install-prod                # 安装生产依赖

# 环境管理
make list                        # 列出项目环境
make info                        # 显示环境详情
make clean-all                   # 清理所有环境
```

### 方式三：直接脚本调用

```bash
# 环境管理器
./scripts/uv-env-manager.sh create myproject python3.12
./scripts/uv-env-manager.sh list
./scripts/uv-env-manager.sh switch myproject

# 快速切换
source scripts/uv-switch.sh dev
source scripts/uv-switch.sh test
```

## ⚙️ 配置

### 环境配置

编辑 `uv-env-manager.sh` 中的配置变量：

```bash
# 全局环境存储路径
VENV_BASE_DIR="$HOME/.uv-envs"

# 默认 Python 版本
DEFAULT_PYTHON="python3.12"

# 环境信息文件
ENV_INFO_FILE=".env-info"
```

**注意**：所有路径配置已经自动优化，工具可以在任何目录中正常运行。

### 项目环境配置

在 `uv-switch.sh` 中添加新环境：

```bash
declare -A ENVIRONMENTS=(
    ["dev"]=".venv-dev"
    ["test"]=".venv-test"
    ["prod"]=".venv-prod"
    ["exp"]=".venv-exp"
    ["your-env"]=".venv-your-env"  # 添加新环境
)

declare -A PYTHON_VERSIONS=(
    ["dev"]="python3.12"
    ["test"]="python3.12"
    ["prod"]="python3.11"
    ["exp"]="python3.13"
    ["your-env"]="python3.12"      # 指定 Python 版本
)
```

### 自动加载 .env 文件

工具会自动查找并加载以下文件中的环境变量：
- `.env`
- `.env.local`
- `.env.development`
- `.env.production`

## 🔧 扩展开发

### 添加新的管理命令

在 `uv-env-manager.sh` 中添加新功能：

```bash
# 添加新的命令处理
case "$1" in
    "your-command")
        your_custom_function "$@"
        ;;
    # ... 其他命令
esac

# 实现自定义函数
your_custom_function() {
    local env_name="$2"
    echo "执行自定义操作: $env_name"
    # 你的逻辑代码
}
```

### 创建自定义别名

在 `uv-aliases.sh` 中添加新别名：

```bash
# 添加自定义别名
alias uv-your-alias="$PROJECT_DIR/uv-env-manager.sh your-command"

# 添加自定义函数
uv-your-function() {
    echo "执行自定义函数"
    # 你的逻辑代码
}
```

### 扩展 Makefile

在 `Makefile` 中添加新目标：

```makefile
# 添加新的环境类型
staging: ## 创建预发布环境
	@$(call create_env,staging,python3.11)

# 添加自定义任务
deploy: prod ## 部署到生产环境
	@echo "部署到生产环境..."
	@$(call activate_and_run,prod,python deploy.py)

# 定义新的函数
define deploy_app
	@echo "部署应用: $(1)"
	# 部署逻辑
endef
```

### 插件系统

创建插件目录结构：

```
plugins/
├── docker/
│   ├── docker-plugin.sh
│   └── README.md
├── git/
│   ├── git-plugin.sh
│   └── README.md
└── monitoring/
    ├── monitor-plugin.sh
    └── README.md
```

插件示例 (`plugins/docker/docker-plugin.sh`)：

```bash
#!/bin/bash

# Docker 集成插件

docker_build() {
    local env_name="$1"
    echo "为环境 $env_name 构建 Docker 镜像..."
    docker build -t "myapp:$env_name" .
}

docker_run() {
    local env_name="$1"
    echo "运行环境 $env_name 的 Docker 容器..."
    docker run -it "myapp:$env_name"
}

# 注册插件命令
case "$1" in
    "docker-build")
        docker_build "$2"
        ;;
    "docker-run")
        docker_run "$2"
        ;;
esac
```

## 🐛 故障排除

### 常见问题

**Q: 环境切换后包找不到？**
```bash
# 确保使用 uv run 命令
uv run python script.py

# 或者正确激活环境
source activate-myenv.sh
```

**Q: 权限错误？**
```bash
# 设置执行权限
chmod +x *.sh

# 检查文件所有权
ls -la *.sh
```

**Q: Python 版本不匹配？**
```bash
# 检查可用的 Python 版本
uv python list

# 安装特定版本
uv python install 3.12
```

### 调试模式

启用详细输出：

```bash
# 设置调试模式
export UV_ENV_DEBUG=1

# 运行命令查看详细信息
./uv-env-manager.sh list
```

### 日志文件

查看操作日志：

```bash
# 日志文件位置
tail -f ~/.uv-envs/uv-manager.log

# 清理日志
> ~/.uv-envs/uv-manager.log
```

## 🤝 贡献指南

我们欢迎所有形式的贡献！

### 开发环境设置

```bash
# 1. Fork 并克隆仓库（需要修改为实际的仓库地址）
# TODO: 替换为您的实际仓库地址
git clone https://github.com/tloneh/uv-multi-env-manager.git
cd uv-multi-env-manager

# 2. 创建开发环境
make dev

# 3. 安装开发依赖
uv-dev
uv pip install -e ".[dev]"

# 4. 运行测试
make test
```

## 🧪 测试

### Linux/macOS 测试
```bash
# 运行示例演示
./example.sh

```

### Windows 测试
```powershell
# 快速验证
.\quick-check-windows.ps1

# 完整功能测试
.\test-windows.ps1

# 运行示例演示
.\example-windows.ps1

```

### 提交规范

- 使用清晰的提交信息
- 遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范
- 添加适当的测试
- 更新相关文档

### Pull Request 流程

1. 创建功能分支：`git checkout -b feature/amazing-feature`
2. 提交更改：`git commit -m 'feat: add amazing feature'`
3. 推送分支：`git push origin feature/amazing-feature`
4. 创建 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

- [UV](https://github.com/astral-sh/uv) - 快速的 Python 包管理器
- [Python](https://www.python.org/) - 强大的编程语言
- tlone and ai (ai真的太好用了)

## 🏗️ 项目目录结构

```
uv-multi-env-manager/
├── 📚 docs/                    # 📖 完整文档
│   ├── README.md              # 项目主文档
│   ├── INSTALLATION.md        # 安装配置指南
│   ├── QUICK-REFERENCE.md     # 命令快速参考
│   ├── UV-ENVIRONMENTS-GUIDE.md # 环境管理详细指南
│   ├── PLATFORM-SUPPORT.md   # 跨平台支持总览
│   ├── MACOS-GUIDE.md         # macOS 使用指南
│   ├── WINDOWS-GUIDE.md       # Windows 使用指南
│   ├── CONTRIBUTING.md        # 贡献指南
│   ├── DOCS-STRUCTURE.md      # 文档结构说明
│   └── LICENSE               # MIT 开源许可证
├── 🛠️ scripts/                 # 🔧 核心脚本
│   ├── uv-env-manager.sh      # Linux/macOS 环境管理器
│   ├── uv-env-manager.ps1     # Windows PowerShell 管理器
│   ├── uv-aliases.sh          # 便捷别名配置
│   └── uv-switch.sh           # 快速环境切换
├── 📋 examples/                # 🎯 示例和测试
│   ├── example.sh             # Linux/macOS 使用示例
│   ├── example-windows.ps1    # Windows 使用示例
│   ├── quick-check-windows.ps1 # Windows 快速检查
│   └── test-windows.ps1       # Windows 功能测试
├── Makefile                   # 🏗️ 项目环境管理
├── .gitignore                 # Git 忽略文件
└── README.md                  # 📄 项目概览
```

