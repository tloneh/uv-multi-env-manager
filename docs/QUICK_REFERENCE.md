# UV 环境管理 - 快速参考

## 🚀 一键开始
```bash
source uv-aliases.sh    # 加载别名
uv-make-dev            # 创建开发环境
uv-dev                 # 切换到开发环境
```

## 📋 常用命令

### 环境管理
| 命令 | 说明 |
|------|------|
| `uv-create <name> [python]` | 创建新环境 |
| `uv-list` | 列出所有环境 |
| `uv-remove <name>` | 删除环境 |
| `uv-info <name>` | 查看环境信息 |

### 快速切换
| 命令 | 环境 | Python版本 |
|------|------|-------------|
| `uv-dev` | 开发环境 | 3.12 |
| `uv-test` | 测试环境 | 3.12 |
| `uv-prod` | 生产环境 | 3.11 |
| `uv-exp` | 实验环境 | 3.13 |

### Make 命令
| 命令 | 说明 |
|------|------|
| `make dev` | 创建开发环境 |
| `make test` | 创建测试环境 |
| `make prod` | 创建生产环境 |
| `make list` | 列出项目环境 |
| `make clean-all` | 清理所有环境 |

### 包管理
| 命令 | 说明 |
|------|------|
| `uv-install <env> <pkg>` | 安装包到指定环境 |
| `uv-run <env> <cmd>` | 在指定环境运行命令 |
| `uv pip install <pkg>` | 在当前环境安装包 |

### 状态查看
| 命令 | 说明 |
|------|------|
| `uv-status` | 查看所有环境状态 |
| `uv-current` | 查看当前激活环境 |
| `uv-help` | 显示帮助信息 |

## 🔧 自定义配置

### 添加新环境类型
编辑 `uv-switch.sh`:
```bash
declare -A ENVIRONMENTS=(
    ["myenv"]=".venv-myenv"
)
declare -A PYTHON_VERSIONS=(
    ["myenv"]="python3.12"
)
```

### 添加新别名
编辑 `uv-aliases.sh`:
```bash
alias uv-myenv="source $PROJECT_DIR/uv-switch.sh myenv"
```

### 添加 Makefile 目标
编辑 `Makefile`:
```makefile
myenv: ## 创建自定义环境
	@$(call create_env,myenv,python3.12)
```

## 🐛 故障排除

| 问题 | 解决方案 |
|------|----------|
| 权限错误 | `chmod +x *.sh` |
| 包找不到 | 使用 `uv run python` |
| 环境切换失败 | 检查 `source` 命令 |
| Python版本错误 | `uv python install 3.12` |

## 📁 文件结构
```
project/
├── uv-env-manager.sh    # 主环境管理器
├── uv-aliases.sh        # 别名配置
├── uv-switch.sh         # 快速切换脚本
├── Makefile            # 自动化任务
├── README.md           # 详细文档
└── QUICK-REFERENCE.md  # 本文件
```
