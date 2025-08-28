# UV 虚拟环境管理 Makefile
# 使用方法: make [target]

.PHONY: help list create-all clean-all dev test prod exp install-dev install-test install-prod

# 默认目标
help:
	@echo "UV 虚拟环境管理"
	@echo ""
	@echo "可用命令:"
	@echo "  make list          - 列出所有环境"
	@echo "  make create-all    - 创建所有环境"
	@echo "  make dev           - 创建并设置开发环境"
	@echo "  make test          - 创建并设置测试环境"
	@echo "  make prod          - 创建并设置生产环境"
	@echo "  make exp           - 创建并设置实验环境"
	@echo "  make install-dev   - 在开发环境中安装依赖"
	@echo "  make install-test  - 在测试环境中安装依赖"
	@echo "  make install-prod  - 在生产环境中安装依赖"
	@echo "  make clean-all     - 删除所有环境"
	@echo "  make info          - 显示环境信息"

# 环境变量配置
# TODO: 如果需要自定义环境目录名称，请修改以下变量
VENV_DEV = .venv-dev
VENV_TEST = .venv-test
VENV_PROD = .venv-prod
VENV_EXP = .venv-exp
# 列出环境状态
list:
	@echo "虚拟环境状态:"
	@echo -n "  开发环境 (dev):  "
	@if [ -d "$(VENV_DEV)" ]; then echo "✓ 已创建"; else echo "✗ 未创建"; fi
	@echo -n "  测试环境 (test): "
	@if [ -d "$(VENV_TEST)" ]; then echo "✓ 已创建"; else echo "✗ 未创建"; fi
	@echo -n "  生产环境 (prod): "
	@if [ -d "$(VENV_PROD)" ]; then echo "✓ 已创建"; else echo "✗ 未创建"; fi
	@echo -n "  实验环境 (exp):  "
	@if [ -d "$(VENV_EXP)" ]; then echo "✓ 已创建"; else echo "✗ 未创建"; fi

# 创建所有环境
create-all: $(VENV_DEV) $(VENV_TEST) $(VENV_PROD) $(VENV_EXP)
	@echo "所有环境创建完成"

# 创建开发环境
$(VENV_DEV):
	@echo "创建开发环境..."
	uv venv $(VENV_DEV) --python python3.12
	@echo "✓ 开发环境创建完成"

dev: $(VENV_DEV)
	@echo "开发环境已准备就绪"
	@echo "激活命令: source $(VENV_DEV)/bin/activate"

# 创建测试环境
$(VENV_TEST):
	@echo "创建测试环境..."
	uv venv $(VENV_TEST) --python python3.12
	@echo "✓ 测试环境创建完成"

test: $(VENV_TEST)
	@echo "测试环境已准备就绪"
	@echo "激活命令: source $(VENV_TEST)/bin/activate"

# 创建生产环境
$(VENV_PROD):
	@echo "创建生产环境..."
	uv venv $(VENV_PROD) --python python3.11
	@echo "✓ 生产环境创建完成"

prod: $(VENV_PROD)
	@echo "生产环境已准备就绪"
	@echo "激活命令: source $(VENV_PROD)/bin/activate"

# 创建实验环境
$(VENV_EXP):
	@echo "创建实验环境..."
	uv venv $(VENV_EXP) --python python3.13
	@echo "✓ 实验环境创建完成"

exp: $(VENV_EXP)
	@echo "实验环境已准备就绪"
	@echo "激活命令: source $(VENV_EXP)/bin/activate"

# 安装开发依赖
install-dev: $(VENV_DEV)
	@echo "在开发环境中安装依赖..."
	VIRTUAL_ENV=$(VENV_DEV) uv pip install -e .
	VIRTUAL_ENV=$(VENV_DEV) uv pip install pytest black flake8 mypy jupyter
	@echo "✓ 开发依赖安装完成"

# 安装测试依赖
install-test: $(VENV_TEST)
	@echo "在测试环境中安装依赖..."
	VIRTUAL_ENV=$(VENV_TEST) uv pip install -e .
	VIRTUAL_ENV=$(VENV_TEST) uv pip install pytest pytest-cov pytest-mock
	@echo "✓ 测试依赖安装完成"

# 安装生产依赖
install-prod: $(VENV_PROD)
	@echo "在生产环境中安装依赖..."
	VIRTUAL_ENV=$(VENV_PROD) uv pip install -e .
	@echo "✓ 生产依赖安装完成"

# 安装实验依赖
install-exp: $(VENV_EXP)
	@echo "在实验环境中安装依赖..."
	VIRTUAL_ENV=$(VENV_EXP) uv pip install -e .
	VIRTUAL_ENV=$(VENV_EXP) uv pip install numpy pandas matplotlib jupyter
	@echo "✓ 实验依赖安装完成"

# 显示环境信息
info:
	@echo "环境详细信息:"
	@if [ -d "$(VENV_DEV)" ]; then \
		echo "开发环境:"; \
		echo "  路径: $(VENV_DEV)"; \
		echo "  Python: $$($(VENV_DEV)/bin/python --version)"; \
		echo "  包数量: $$(VIRTUAL_ENV=$(VENV_DEV) uv pip list | wc -l)"; \
		echo ""; \
	fi
	@if [ -d "$(VENV_TEST)" ]; then \
		echo "测试环境:"; \
		echo "  路径: $(VENV_TEST)"; \
		echo "  Python: $$($(VENV_TEST)/bin/python --version)"; \
		echo "  包数量: $$(VIRTUAL_ENV=$(VENV_TEST) uv pip list | wc -l)"; \
		echo ""; \
	fi
	@if [ -d "$(VENV_PROD)" ]; then \
		echo "生产环境:"; \
		echo "  路径: $(VENV_PROD)"; \
		echo "  Python: $$($(VENV_PROD)/bin/python --version)"; \
		echo "  包数量: $$(VIRTUAL_ENV=$(VENV_PROD) uv pip list | wc -l)"; \
		echo ""; \
	fi
	@if [ -d "$(VENV_EXP)" ]; then \
		echo "实验环境:"; \
		echo "  路径: $(VENV_EXP)"; \
		echo "  Python: $$($(VENV_EXP)/bin/python --version)"; \
		echo "  包数量: $$(VIRTUAL_ENV=$(VENV_EXP) uv pip list | wc -l)"; \
		echo ""; \
	fi

# 清理所有环境
clean-all:
	@echo "删除所有虚拟环境..."
	@if [ -d "$(VENV_DEV)" ]; then rm -rf $(VENV_DEV) && echo "✓ 删除开发环境"; fi
	@if [ -d "$(VENV_TEST)" ]; then rm -rf $(VENV_TEST) && echo "✓ 删除测试环境"; fi
	@if [ -d "$(VENV_PROD)" ]; then rm -rf $(VENV_PROD) && echo "✓ 删除生产环境"; fi
	@if [ -d "$(VENV_EXP)" ]; then rm -rf $(VENV_EXP) && echo "✓ 删除实验环境"; fi
	@echo "所有环境已清理完成"

# 运行测试（在测试环境中）
run-tests: $(VENV_TEST) install-test
	@echo "在测试环境中运行测试..."
	VIRTUAL_ENV=$(VENV_TEST) $(VENV_TEST)/bin/python -m pytest

# 格式化代码（在开发环境中）
format: $(VENV_DEV) install-dev
	@echo "格式化代码..."
	VIRTUAL_ENV=$(VENV_DEV) $(VENV_DEV)/bin/python -m black .

# 类型检查（在开发环境中）
typecheck: $(VENV_DEV) install-dev
	@echo "运行类型检查..."
	VIRTUAL_ENV=$(VENV_DEV) $(VENV_DEV)/bin/python -m mypy epflower
