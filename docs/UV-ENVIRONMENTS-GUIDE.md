# UV 多虚拟环境管理指南

本项目提供了多种方式来管理 UV 虚拟环境，让您可以轻松地在不同的开发环境之间切换。

## 🚀 快速开始

### 方案一：环境管理器脚本 (推荐)

使用 `uv-env-manager.sh` 脚本来管理所有虚拟环境：

```bash
# 查看帮助
./uv-env-manager.sh help

# 创建新环境
./uv-env-manager.sh create myproject python3.12

# 列出所有环境
./uv-env-manager.sh list

# 在指定环境中安装包
./uv-env-manager.sh install myproject numpy pandas

# 在指定环境中运行命令
./uv-env-manager.sh run myproject python script.py

# 切换到指定环境（生成激活脚本）
./uv-env-manager.sh switch myproject
source activate-myproject.sh

# 删除环境
./uv-env-manager.sh remove myproject
```

### 方案二：Makefile 自动化 (适合项目开发)

使用 Makefile 来管理项目级别的虚拟环境：

```bash
# 查看所有可用命令
make help

# 查看环境状态
make list

# 创建开发环境
make dev

# 创建测试环境
make test

# 创建生产环境
make prod

# 创建实验环境
make exp

# 安装开发依赖
make install-dev

# 运行测试
make run-tests

# 格式化代码
make format

# 显示详细信息
make info

# 清理所有环境
make clean-all
```

### 方案三：快速切换脚本

使用 `uv-switch.sh` 进行快速环境切换：

```bash
# 查看可用环境
source uv-switch.sh list

# 切换到开发环境
source uv-switch.sh dev

# 切换到测试环境
source uv-switch.sh test

# 创建新环境
source uv-switch.sh create exp
```

## 📁 环境目录结构

### 全局环境管理器
- 环境存储位置: `~/.uv-envs/`
- 配置文件: `~/.uv-env-config`
- 历史记录: `~/.uv-envs/.env_history`

### 项目级环境
- 开发环境: `.venv-dev/`
- 测试环境: `.venv-test/`
- 生产环境: `.venv-prod/`
- 实验环境: `.venv-exp/`
- 主环境: `.venv/`

## 🛠️ 环境配置

### Python 版本配置
- 开发/测试环境: Python 3.12
- 生产环境: Python 3.11
- 实验环境: Python 3.13

### 依赖管理
每个环境可以有不同的依赖配置：

**开发环境依赖:**
- pytest (测试框架)
- black (代码格式化)
- flake8 (代码检查)
- mypy (类型检查)
- jupyter (交互式开发)

**测试环境依赖:**
- pytest
- pytest-cov (覆盖率)
- pytest-mock (模拟)

**生产环境依赖:**
- 只包含运行时必需的依赖

**实验环境依赖:**
- numpy, pandas, matplotlib
- jupyter

## 💡 使用技巧

### 1. 环境变量支持
所有脚本都支持自动加载 `.env` 文件：

```bash
# .env 文件示例
DATABASE_URL=sqlite:///dev.db
DEBUG=True
SECRET_KEY=your-secret-key
```

### 2. 批量操作
```bash
# 创建所有项目环境
make create-all

# 安装所有环境的依赖
make install-dev install-test install-prod
```

### 3. 环境信息查看
```bash
# 查看环境详细信息
./uv-env-manager.sh info myproject
make info
```

### 4. 快速激活
```bash
# 生成激活脚本
./uv-env-manager.sh switch myproject

# 激活环境
source activate-myproject.sh

# 退出环境
deactivate
```

## 🔧 高级用法

### 自定义环境路径
修改 `uv-env-manager.sh` 中的 `VENV_BASE_DIR` 变量：

```bash
VENV_BASE_DIR="/path/to/your/envs"
```

### 添加新的项目环境
在 `uv-switch.sh` 中添加新环境：

```bash
declare -A ENVIRONMENTS=(
    ["dev"]=".venv-dev"
    ["test"]=".venv-test"
    ["prod"]=".venv-prod"
    ["exp"]=".venv-exp"
    ["new-env"]=".venv-new"  # 添加新环境
)
```

### 自定义 Python 版本
```bash
# 创建使用特定 Python 版本的环境
./uv-env-manager.sh create myproject python3.11
```

## 🚨 注意事项

1. **环境隔离**: 每个环境都是完全隔离的，包和配置不会相互影响
2. **Python 版本**: 确保系统中安装了所需的 Python 版本
3. **权限问题**: 某些操作可能需要适当的文件系统权限
4. **磁盘空间**: 多个环境会占用更多磁盘空间
5. **环境变量**: 使用 `source` 命令来正确加载环境变量

## 🔍 故障排除

### 常见问题

**问题 1: 环境创建失败**
```bash
# 检查 Python 版本是否可用
python3.12 --version

# 检查 uv 版本
uv --version
```

**问题 2: 包安装失败**
```bash
# 检查环境是否存在
./uv-env-manager.sh list

# 手动激活环境后安装
source ~/.uv-envs/myproject/bin/activate
pip install package_name
```

**问题 3: 环境变量未加载**
```bash
# 确保使用 source 命令
source uv-switch.sh dev

# 检查 .env 文件格式
cat .env
```

## 📚 相关命令参考

### UV 基础命令
```bash
# 创建虚拟环境
uv venv path/to/env --python python3.12

# 在环境中安装包
VIRTUAL_ENV=path/to/env uv pip install package

# 列出环境中的包
VIRTUAL_ENV=path/to/env uv pip list
```

### 环境激活/退出
```bash
# 激活环境
source path/to/env/bin/activate

# 退出环境
deactivate
```

---

选择最适合您工作流程的方案，开始高效的多环境开发！
