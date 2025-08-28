# 🪟 Windows 使用指南

UV Multi-Environment Manager 在 Windows 上的完整使用指南。

## 📋 系统要求

- **Windows版本**: Windows 10 或 Windows 11
- **PowerShell**: 5.1+ 或 PowerShell Core 7+
- **Python**: 3.11+ 
- **可选**: WSL2, Git Bash

## 🚀 安装方案

### 方案一：PowerShell 原生支持 (推荐)

#### 1. 安装 UV
```powershell
# 方法1: 官方安装脚本（推荐）
irm https://astral.sh/uv/install.ps1 | iex

# 方法2: 使用 Scoop
scoop install uv

# 方法3: 使用 pip
pip install uv

# 验证安装
uv --version
```

#### 2. 获取工具
```powershell
# 克隆项目
git clone https://github.com/YOUR-USERNAME/YOUR-REPO.git
cd uv-multi-env-manager

# 设置执行策略（如果需要）
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 测试PowerShell版本
.\uv-env-manager.ps1 help
```

### 方案二：WSL2 支持

#### 1. 安装 WSL2
```powershell
# 在管理员PowerShell中运行
wsl --install

# 安装Ubuntu（推荐）
wsl --install -d Ubuntu

# 重启计算机后，设置Ubuntu用户
```

#### 2. 在WSL中使用
```bash
# 在WSL Ubuntu中
cd /mnt/c/path/to/uv-multi-env-manager

# 安装UV
curl -LsSf https://astral.sh/uv/install.sh | sh

# 设置权限
chmod +x *.sh

# 使用Linux版本
./example.sh
```

### 方案三：Git Bash

#### 1. 安装 Git for Windows
下载并安装 [Git for Windows](https://git-scm.com/download/win)

#### 2. 在Git Bash中使用
```bash
# 在Git Bash中
cd /c/path/to/uv-multi-env-manager
chmod +x *.sh
source uv-aliases.sh

# 使用Bash版本功能
uv-create myproject python3.12
```

## 🔧 PowerShell 配置

### 1. 创建PowerShell配置文件
```powershell
# 检查配置文件路径
$PROFILE

# 创建配置文件（如果不存在）
if (!(Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force
}

# 编辑配置文件
notepad $PROFILE
```

### 2. 添加UV管理器别名
```powershell
# 在 $PROFILE 文件中添加以下内容

# UV Multi-Environment Manager 配置
$UVToolDir = "C:\path\to\uv-multi-env-manager"

# 基本别名
function uv-create { & "$UVToolDir\uv-env-manager.ps1" create @args }
function uv-list { & "$UVToolDir\uv-env-manager.ps1" list @args }
function uv-remove { & "$UVToolDir\uv-env-manager.ps1" remove @args }
function uv-install { & "$UVToolDir\uv-env-manager.ps1" install @args }
function uv-run { & "$UVToolDir\uv-env-manager.ps1" run @args }
function uv-activate { & "$UVToolDir\uv-env-manager.ps1" activate @args }

# 帮助函数
function uv-help {
    Write-Host "UV 环境管理器 - Windows PowerShell版本" -ForegroundColor Blue
    Write-Host ""
    Write-Host "基本命令:"
    Write-Host "  uv-create <name> [python]  - 创建新环境"
    Write-Host "  uv-list                    - 列出所有环境"
    Write-Host "  uv-remove <name>           - 删除环境"
    Write-Host "  uv-install <name> <pkg>    - 安装包到环境"
    Write-Host "  uv-run <name> <cmd>        - 在环境中运行命令"
    Write-Host "  uv-activate <name>         - 生成激活脚本"
    Write-Host ""
    Write-Host "使用示例:"
    Write-Host "  uv-create myproject python3.12"
    Write-Host "  uv-install myproject numpy pandas"
    Write-Host "  uv-activate myproject"
    Write-Host "  . .\activate-myproject.ps1"
}

# 状态函数
function uv-status {
    Write-Host "UV 环境状态概览" -ForegroundColor Blue
    Write-Host ""
    & "$UVToolDir\uv-env-manager.ps1" list
    
    if ($env:VIRTUAL_ENV) {
        Write-Host ""
        Write-Host "当前激活环境: $(Split-Path $env:VIRTUAL_ENV -Leaf)" -ForegroundColor Green
        Write-Host "路径: $env:VIRTUAL_ENV"
    } else {
        Write-Host ""
        Write-Host "当前没有激活的环境" -ForegroundColor Yellow
    }
}

Write-Host "✓ UV 环境管理器已加载" -ForegroundColor Green
Write-Host "使用 uv-help 查看可用命令" -ForegroundColor Cyan
```

### 3. 重新加载配置
```powershell
# 重新加载PowerShell配置
. $PROFILE

# 或重启PowerShell
```

## 🛠️ 使用方法

### PowerShell 基本操作
```powershell
# 创建环境
uv-create myproject python3.12

# 列出环境
uv-list

# 安装包
uv-install myproject numpy pandas matplotlib

# 运行脚本
uv-run myproject python script.py

# 激活环境
uv-activate myproject
. .\activate-myproject.ps1

# 在激活的环境中工作
python --version
pip list

# 退出环境
deactivate
```

### 批处理脚本集成
```batch
@echo off
REM create-env.bat - 批处理脚本示例

set PROJECT_NAME=%1
set PYTHON_VERSION=%2

if "%PROJECT_NAME%"=="" (
    echo 请提供项目名称
    exit /b 1
)

if "%PYTHON_VERSION%"=="" (
    set PYTHON_VERSION=python3.12
)

echo 创建项目环境: %PROJECT_NAME%
powershell -Command "& '.\uv-env-manager.ps1' create %PROJECT_NAME% %PYTHON_VERSION%"

echo 安装基础包...
powershell -Command "& '.\uv-env-manager.ps1' install %PROJECT_NAME% requests numpy"

echo ✓ 项目环境创建完成
```

## 🪟 Windows 特殊功能

### 1. 任务栏快捷方式
```powershell
# 创建桌面快捷方式
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\UV Manager.lnk")
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-NoExit -Command `"cd C:\path\to\uv-multi-env-manager; uv-help`""
$Shortcut.WorkingDirectory = "C:\path\to\uv-multi-env-manager"
$Shortcut.IconLocation = "powershell.exe,0"
$Shortcut.Save()
```

### 2. 右键菜单集成
```powershell
# 添加到文件夹右键菜单
$regPath = "HKEY_CLASSES_ROOT\Directory\shell\UVManager"
New-Item -Path "Registry::$regPath" -Force
Set-ItemProperty -Path "Registry::$regPath" -Name "(Default)" -Value "在此处打开UV管理器"
Set-ItemProperty -Path "Registry::$regPath" -Name "Icon" -Value "powershell.exe,0"

New-Item -Path "Registry::$regPath\command" -Force
Set-ItemProperty -Path "Registry::$regPath\command" -Name "(Default)" -Value "powershell.exe -NoExit -Command `"cd '%1'; C:\path\to\uv-multi-env-manager\uv-env-manager.ps1 help`""
```

### 3. Windows Terminal 集成
```json
// 在 Windows Terminal 的 settings.json 中添加配置
{
    "profiles": {
        "list": [
            {
                "name": "UV Manager",
                "commandline": "powershell.exe -NoExit -Command \"cd C:\\path\\to\\uv-multi-env-manager; uv-help\"",
                "icon": "🐍",
                "colorScheme": "Campbell",
                "startingDirectory": "C:\\path\\to\\uv-multi-env-manager"
            }
        ]
    }
}
```

## 🔍 故障排除

### 常见问题

#### 1. 执行策略问题
```powershell
# 查看当前执行策略
Get-ExecutionPolicy

# 设置执行策略
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 临时绕过执行策略
powershell -ExecutionPolicy Bypass -File .\uv-env-manager.ps1
```

#### 2. 路径问题
```powershell
# 检查PATH环境变量
$env:PATH -split ';'

# 添加UV到PATH
$env:PATH += ";$env:USERPROFILE\.local\bin"

# 永久添加到PATH
[Environment]::SetEnvironmentVariable("PATH", $env:PATH + ";$env:USERPROFILE\.local\bin", "User")
```

#### 3. Python版本问题
```powershell
# 检查Python安装
python --version
py -0  # 列出所有Python版本

# 使用特定版本
py -3.12 -m pip install uv
```

#### 4. 权限问题
```powershell
# 以管理员身份运行PowerShell
Start-Process powershell -Verb RunAs

# 检查文件权限
Get-Acl .\uv-env-manager.ps1
```

#### 5. 网络问题
```powershell
# 设置代理（如果需要）
$env:HTTP_PROXY = "http://proxy.company.com:8080"
$env:HTTPS_PROXY = "http://proxy.company.com:8080"

# 或在UV中设置
uv config set global.proxy "http://proxy.company.com:8080"
```

### 性能优化

#### 1. 缓存配置
```powershell
# 设置UV缓存目录
$env:UV_CACHE_DIR = "$env:USERPROFILE\.cache\uv"

# 清理缓存
uv cache clean
```

#### 2. 并行安装
```powershell
# 启用并行安装
$env:UV_CONCURRENT_INSTALLS = "4"
```

## 🧪 测试和验证

### Windows兼容性测试
```powershell
# test-windows.ps1

Write-Host "=== Windows 兼容性测试 ===" -ForegroundColor Blue
Write-Host "Windows版本: $((Get-WmiObject Win32_OperatingSystem).Caption)"
Write-Host "PowerShell版本: $($PSVersionTable.PSVersion)"
Write-Host "Python版本: $(python --version 2>$null)"
Write-Host "UV版本: $(uv --version 2>$null)"

# 测试环境创建
Write-Host "测试环境创建..." -ForegroundColor Yellow
.\uv-env-manager.ps1 create test-windows python3.12

# 测试包安装
Write-Host "测试包安装..." -ForegroundColor Yellow
.\uv-env-manager.ps1 install test-windows requests

# 测试环境激活
Write-Host "测试环境激活..." -ForegroundColor Yellow
.\uv-env-manager.ps1 activate test-windows
. .\activate-test-windows.ps1
python -c "import requests; print('✅ 包导入成功')"
deactivate

# 清理
.\uv-env-manager.ps1 remove test-windows

Write-Host "✅ Windows 兼容性测试完成" -ForegroundColor Green
```

### 性能基准测试
```powershell
# benchmark-windows.ps1

Write-Host "=== Windows 性能基准测试 ===" -ForegroundColor Blue

# 测试环境创建速度
$createTime = Measure-Command { .\uv-env-manager.ps1 create benchmark-test python3.12 }
Write-Host "环境创建时间: $($createTime.TotalSeconds) 秒"

# 测试包安装速度
$installTime = Measure-Command { .\uv-env-manager.ps1 install benchmark-test numpy pandas }
Write-Host "包安装时间: $($installTime.TotalSeconds) 秒"

# 清理
.\uv-env-manager.ps1 remove benchmark-test

Write-Host "✅ 性能测试完成" -ForegroundColor Green
```

## 🔧 高级配置

### 1. 企业环境配置
```powershell
# 企业代理设置
$env:UV_HTTP_PROXY = "http://proxy.company.com:8080"
$env:UV_HTTPS_PROXY = "http://proxy.company.com:8080"
$env:UV_NO_PROXY = "localhost,127.0.0.1,.company.com"

# 企业证书
$env:UV_CERT = "C:\certs\company-ca.pem"
```

### 2. 多用户配置
```powershell
# 系统级配置
$systemConfig = "$env:ProgramData\UV\config.toml"
New-Item -ItemType Directory -Path (Split-Path $systemConfig) -Force

# 用户级配置
$userConfig = "$env:APPDATA\UV\config.toml"
```

### 3. 自动化部署
```powershell
# deploy.ps1 - 自动化部署脚本

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName,
    
    [string]$Environment = "prod"
)

Write-Host "部署项目: $ProjectName 到 $Environment 环境" -ForegroundColor Blue

# 创建生产环境
.\uv-env-manager.ps1 create "$ProjectName-$Environment" python3.11

# 安装依赖
.\uv-env-manager.ps1 install "$ProjectName-$Environment" -r requirements.txt

# 运行测试
.\uv-env-manager.ps1 run "$ProjectName-$Environment" python -m pytest

# 启动应用
.\uv-env-manager.ps1 run "$ProjectName-$Environment" python app.py

Write-Host "✅ 部署完成" -ForegroundColor Green
```

## 📱 集成开发环境

### Visual Studio Code
```json
// .vscode/settings.json
{
    "python.defaultInterpreterPath": "${env:USERPROFILE}\\.uv-envs\\myproject\\Scripts\\python.exe",
    "python.terminal.activateEnvironment": true,
    "python.envFile": "${workspaceFolder}\\.env"
}
```

### PyCharm
1. 打开 Settings → Project → Python Interpreter
2. 点击齿轮图标 → Add
3. 选择 Existing Environment
4. 路径设置为: `%USERPROFILE%\.uv-envs\myproject\Scripts\python.exe`

### Jupyter Notebook
```powershell
# 在环境中安装Jupyter
uv-install myproject jupyter ipykernel

# 注册内核
uv-run myproject python -m ipykernel install --user --name myproject --display-name "Python (myproject)"

# 启动Jupyter
uv-run myproject jupyter notebook
```

## 🎯 最佳实践

### 1. 项目结构
```
C:\Development\
├── Projects\
│   ├── project1\
│   │   ├── src\
│   │   ├── tests\
│   │   └── requirements.txt
│   └── project2\
├── Tools\
│   └── uv-multi-env-manager\
└── Environments\  # 可选：自定义环境位置
    ├── project1-dev\
    └── project1-prod\
```

### 2. 环境命名约定
```powershell
# 使用描述性名称
uv-create myapp-dev python3.12      # 开发环境
uv-create myapp-test python3.12     # 测试环境
uv-create myapp-prod python3.11     # 生产环境
uv-create myapp-exp python3.13      # 实验环境
```

### 3. 依赖管理
```powershell
# 导出依赖
uv-run myproject pip freeze > requirements.txt

# 分环境依赖文件
# requirements-dev.txt    - 开发依赖
# requirements-test.txt   - 测试依赖
# requirements-prod.txt   - 生产依赖

# 安装特定依赖
uv-install myproject-dev -r requirements-dev.txt
```

---

🪟 **在 Windows 上享受强大的 Python 环境管理！**
