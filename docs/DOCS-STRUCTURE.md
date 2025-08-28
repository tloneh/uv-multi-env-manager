# 📚 项目文档结构

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

## 🎯 核心文档

### 📖 主要文档
- **[README.md](README.md)** - 项目主文档，包含完整的使用指南
- **[INSTALLATION.md](INSTALLATION.md)** - 详细的安装和配置说明
- **[QUICK-REFERENCE.md](QUICK-REFERENCE.md)** - 常用命令快速参考
- **[UV-ENVIRONMENTS-GUIDE.md](UV-ENVIRONMENTS-GUIDE.md)** - 环境管理详细指南

### 🌍 跨平台支持
- **[PLATFORM-SUPPORT.md](PLATFORM-SUPPORT.md)** - 跨平台支持总览
- **[MACOS-GUIDE.md](MACOS-GUIDE.md)** - macOS 特定使用指南
- **[WINDOWS-GUIDE.md](WINDOWS-GUIDE.md)** - Windows 特定使用指南

### 🤝 开发文档
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - 贡献指南和开发规范
- **[LICENSE](LICENSE)** - MIT 开源许可证

## 🛠️ 脚本文件

### 🐧 Linux/macOS 脚本
- **`scripts/uv-env-manager.sh`** - 核心环境管理器
- **`scripts/uv-aliases.sh`** - 便捷别名配置
- **`scripts/uv-switch.sh`** - 快速环境切换

### 🪟 Windows 脚本
- **`scripts/uv-env-manager.ps1`** - PowerShell 环境管理器

## 📋 示例和测试

### 🎯 使用示例
- **`examples/example.sh`** - Linux/macOS 使用示例脚本
- **`examples/example-windows.ps1`** - Windows 使用示例脚本

### 🧪 测试工具
- **`examples/quick-check-windows.ps1`** - Windows 快速环境检查
- **`examples/test-windows.ps1`** - Windows 完整功能测试

## 📋 文档阅读顺序

### 🚀 新用户推荐
1. **[../README.md](../README.md)** - 项目概览和快速开始
2. **[README.md](README.md)** - 了解项目详情和完整功能
3. **[QUICK-REFERENCE.md](QUICK-REFERENCE.md)** - 学习常用命令
4. **平台特定指南** - 根据您的操作系统选择相应指南

### 🔧 高级用户
1. **[INSTALLATION.md](INSTALLATION.md)** - 详细配置和自定义
2. **[UV-ENVIRONMENTS-GUIDE.md](UV-ENVIRONMENTS-GUIDE.md)** - 深入环境管理
3. **[CONTRIBUTING.md](CONTRIBUTING.md)** - 参与项目开发

## 🎯 文档特点

- ✅ **结构清晰** - 脚本、文档、示例分离
- ✅ **简洁明了** - 删除了冗余和临时文档
- ✅ **用户友好** - 提供不同层次的使用指南
- ✅ **跨平台完整** - 覆盖 Linux、macOS、Windows
- ✅ **开发友好** - 包含完整的贡献指南

## 🚀 快速访问

### 📖 开始使用
- 项目概览: [../README.md](../README.md)
- 完整文档: [README.md](README.md)
- 快速参考: [QUICK-REFERENCE.md](QUICK-REFERENCE.md)

### 🛠️ 使用脚本
- Linux/macOS: `../scripts/uv-env-manager.sh`
- Windows: `../scripts/uv-env-manager.ps1`

### 📋 运行示例
- Linux/macOS: `../examples/example.sh`
- Windows: `../examples/example-windows.ps1`

---

💡 **提示**: 从项目根目录的 [README.md](../README.md) 开始，它提供了项目的完整概览！
