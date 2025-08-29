# UV Multi-Environment Manager 安装和配置指南

> 📖 本文档提供详细的安装配置说明。如需快速开始，请参考 [README.md](README.md#-快速开始)。

## ⚙️ 详细配置说明
## ⚙️ 配置自定义

### 需要修改的配置项

以下是您可能需要根据实际情况修改的配置项：

#### 1. 路径配置

**文件：`uv-env-manager.sh`**
```bash
# 自定义虚拟环境存储位置
# TODO: 如果需要自定义虚拟环境存储位置，请修改以下路径
VENV_BASE_DIR="$HOME/.uv-envs"  # 所有虚拟环境的基础目录
CONFIG_FILE="$HOME/.uv-env-config"
```

**注意**：路径配置已经自动优化，工具目录会自动检测，无需手动配置。

#### 2. 环境目录名称

**文件：`Makefile`**
```bash
# 第20-23行：自定义环境目录名称
# TODO: 如果需要自定义环境目录名称，请修改以下变量
VENV_DEV = .venv-dev
VENV_TEST = .venv-test
VENV_PROD = .venv-prod
VENV_EXP = .venv-exp
```

**文件：`uv-switch.sh`**
```bash
# 环境映射配置（需要根据实际情况修改）
declare -A ENVIRONMENTS=(
    ["dev"]=".venv-dev"
    ["test"]=".venv-test"
    ["prod"]=".venv-prod"
    ["exp"]=".venv-exp"
    # 添加您的自定义环境
    # ["your-env"]=".venv-your-env"
)

# Python 版本配置
declare -A PYTHON_VERSIONS=(
    ["dev"]="python3.12"
    ["test"]="python3.12"
    ["prod"]="python3.11"
    ["exp"]="python3.13"
    # 添加您的自定义版本
    # ["your-env"]="python3.12"
)
```

#### 3. 项目信息（如果要发布到 GitHub）

**文件：`README.md`**

需要替换以下占位符：
- `tloneh` → GitHub 用户名
- `uv-multi-env-manager` → 仓库名称
- `YOUR-EMAIL@example.com` → 您的邮箱地址

搜索并替换这些内容：
```bash
# 使用 sed 批量替换（请先备份文件）
sed -i 's/YOUR-USERNAME/tloneh/g' README.md
sed -i 's/YOUR-REPO/uv-multi-env-manager/g' README.md
sed -i 's/YOUR-EMAIL@example.com/your-email@example.com/g' README.md
```

## 🔧 高级配置

### 1. 自定义 Python 版本

如果您需要使用特定的 Python 版本，请确保系统中已安装：

```bash
# 查看可用的 Python 版本
uv python list

# 安装特定版本（如果需要）
uv python install 3.11
uv python install 3.12
uv python install 3.13
```

### 2. 环境变量自动加载

工具会自动查找并加载以下环境变量文件：
- `.env`
- `.env.local`
- `.env.development`
- `.env.production`

创建 `.env` 文件示例：
```bash
# .env 文件示例
DATABASE_URL=sqlite:///app.db
DEBUG=True
SECRET_KEY=your-secret-key
```

### 3. 自定义依赖包

修改 `Makefile` 中的依赖安装部分：

```makefile
# 开发依赖（第75-78行）
install-dev: $(VENV_DEV)
	@echo "在开发环境中安装依赖..."
	VIRTUAL_ENV=$(VENV_DEV) uv pip install -e .
	# TODO: 根据项目需要修改开发依赖
	VIRTUAL_ENV=$(VENV_DEV) uv pip install pytest black flake8 mypy jupyter
	@echo "✓ 开发依赖安装完成"
```

## 🧪 验证安装

安装完成后，请运行示例脚本验证：

```bash
./example.sh
```

或参考 [README.md](README.md#-快速开始) 中的快速开始指南。

## 🐛 常见问题

### Q: 权限错误
```bash
# 解决方案：设置执行权限
chmod +x *.sh
```

### Q: UV 命令找不到
```bash
# 解决方案：重新安装 UV
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc
```

### Q: Python 版本不匹配
```bash
# 解决方案：检查并安装所需版本
uv python list
uv python install 3.12
```

### Q: 别名不生效
```bash
# 解决方案：重新加载别名
source uv-aliases.sh

# 或者检查路径是否正确
echo $PROJECT_DIR
```

## 📝 使用建议

1. **开发环境**：建议将工具目录添加到 PATH 或创建符号链接
2. **团队协作**：统一配置文件，确保团队成员使用相同的环境设置
3. **版本控制**：将配置文件加入版本控制，但排除实际的虚拟环境目录
4. **备份**：定期备份环境配置和依赖列表

## 🔄 更新工具

```bash
# 如果从 Git 仓库安装
git pull origin main

# 重新设置权限
chmod +x *.sh

# 重新加载别名
source uv-aliases.sh
```

---

如果您在安装或配置过程中遇到问题，请参考 [故障排除指南](README.md#-故障排除) 或提交 Issue。
