# 贡献指南

感谢您对 UV Multi-Environment Manager 项目的关注！我们欢迎各种形式的贡献。

## 🤝 如何贡献

### 报告问题
- 使用 [GitHub Issues](https://github.com/tloneh/uv-multi-env-manager/issues) 报告 bug
- 提供详细的错误信息和复现步骤
- 包含系统信息（OS、Python版本、UV版本）

### 功能请求
- 在 Issues 中描述新功能需求
- 解释功能的用途和价值
- 提供使用场景示例

### 代码贡献
1. Fork 项目仓库
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

## 📝 开发规范

### 代码风格
- 使用 4 空格缩进
- 函数名使用下划线命名法
- 添加适当的注释
- 保持代码简洁易读

### 提交信息规范
使用 [Conventional Commits](https://www.conventionalcommits.org/) 格式：

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

类型说明：
- `feat`: 新功能
- `fix`: 修复 bug
- `docs`: 文档更新
- `style`: 代码格式调整
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建过程或辅助工具的变动

### 测试要求
- 为新功能添加测试
- 确保所有测试通过
- 测试覆盖率不低于 80%

## 🔧 开发环境设置

```bash
# 1. 克隆仓库
git clone https://github.com/tloneh/uv-multi-env-manager.git
cd uv-multi-env

# 2. 设置开发环境
make dev
source uv-aliases.sh
uv-dev

# 3. 安装开发依赖
uv pip install -e ".[dev]"

# 4. 运行测试
./run-tests.sh
```

## 📋 Pull Request 检查清单

提交 PR 前请确认：

- [ ] 代码遵循项目风格规范
- [ ] 添加了适当的测试
- [ ] 所有测试通过
- [ ] 更新了相关文档
- [ ] 提交信息符合规范
- [ ] 没有引入破坏性变更（或已在 PR 中说明）

## 🏗️ 项目结构

```
uv-multi-env/
├── uv-env-manager.sh      # 主环境管理器
├── uv-aliases.sh          # 别名配置
├── uv-switch.sh           # 快速切换脚本
├── Makefile              # 自动化任务
├── tests/                # 测试文件
│   ├── test-manager.sh
│   ├── test-aliases.sh
│   └── test-makefile.sh
├── docs/                 # 文档
│   ├── README.md
│   ├── QUICK-REFERENCE.md
│   └── CONTRIBUTING.md
├── examples/             # 示例
│   ├── basic-usage/
│   └── advanced-config/
└── plugins/              # 插件系统
    ├── docker/
    ├── git/
    └── monitoring/
```

## 🧪 测试指南

### 运行测试
```bash
# 运行所有测试
./run-tests.sh

# 运行特定测试
./tests/test-manager.sh

# 运行测试并生成覆盖率报告
./run-tests.sh --coverage
```

### 编写测试
测试文件命名规范：`test-<component>.sh`

```bash
#!/bin/bash
# tests/test-example.sh

source "$(dirname "$0")/../test-framework.sh"

test_example_function() {
    # 测试逻辑
    local result=$(example_function "input")
    assert_equals "expected" "$result"
}

# 运行测试
run_tests
```

## 📚 文档贡献

### 文档类型
- **README.md**: 项目主文档
- **QUICK-REFERENCE.md**: 快速参考
- **API.md**: API 文档
- **EXAMPLES.md**: 使用示例

### 文档规范
- 使用 Markdown 格式
- 包含代码示例
- 保持内容更新
- 添加适当的链接

## 🎯 开发路线图

### 短期目标
- [ ] 添加单元测试框架
- [ ] 实现插件系统
- [ ] 支持配置文件
- [ ] 添加日志功能

### 中期目标
- [ ] Web 界面
- [ ] Docker 集成
- [ ] CI/CD 支持
- [ ] 性能优化

### 长期目标
- [ ] 多平台支持
- [ ] 云环境集成
- [ ] 企业级功能
- [ ] 社区生态

## 🏷️ 发布流程

### 版本号规范
使用 [Semantic Versioning](https://semver.org/)：
- `MAJOR.MINOR.PATCH`
- 破坏性变更：递增 MAJOR
- 新功能：递增 MINOR  
- Bug 修复：递增 PATCH

### 发布步骤
1. 更新版本号
2. 更新 CHANGELOG.md
3. 创建 Git 标签
4. 发布 GitHub Release
5. 更新文档

## 🙋‍♀️ 获取帮助

如果您在贡献过程中遇到问题：

- 查看 [FAQ](docs/FAQ.md)
- 在 [Discussions](https://github.com/tloneh/uv-multi-env-manager/discussions) 中提问
- 联系维护者：your-email@example.com

## 📄 许可证

通过贡献代码，您同意您的贡献将在 MIT 许可证下发布。

---

再次感谢您的贡献！🎉
