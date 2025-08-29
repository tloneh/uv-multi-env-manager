# UV 虚拟环境管理器 - PowerShell版本
# 使用方法: .\uv-env-manager.ps1 [command] [env_name] [options]

param(
    [Parameter(Position=0)]
    [string]$Command,
    
    [Parameter(Position=1)]
    [string]$EnvName,
    
    [Parameter(Position=2)]
    [string]$PythonVersion = "python3.12",
    
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$RemainingArgs
)

# 配置
$VenvBaseDir = "$env:USERPROFILE\.uv-envs"
$ConfigFile = "$env:USERPROFILE\.uv-env-config"

# 颜色定义
$Colors = @{
    Red = "Red"
    Green = "Green"
    Yellow = "Yellow"
    Blue = "Blue"
    Cyan = "Cyan"
}

# 帮助信息
function Show-Help {
    Write-Host "UV 虚拟环境管理器 - PowerShell版本" -ForegroundColor $Colors.Blue
    Write-Host ""
    Write-Host "使用方法: .\uv-env-manager.ps1 [command] [env_name] [options]"
    Write-Host ""
    Write-Host "命令:"
    Write-Host "  create <env_name> [python_version]  - 创建新的虚拟环境"
    Write-Host "  list                                - 列出所有虚拟环境"
    Write-Host "  remove <env_name>                   - 删除虚拟环境"
    Write-Host "  info <env_name>                     - 显示虚拟环境信息"
    Write-Host "  run <env_name> <command>            - 在指定环境中运行命令"
    Write-Host "  install <env_name> <packages>       - 在指定环境中安装包"
    Write-Host "  activate <env_name>                 - 生成激活脚本"
    Write-Host ""
    Write-Host "示例:"
    Write-Host "  .\uv-env-manager.ps1 create myproject python3.12"
    Write-Host "  .\uv-env-manager.ps1 list"
    Write-Host "  .\uv-env-manager.ps1 install myproject numpy pandas"
}

# 确保基础目录存在
function Ensure-BaseDir {
    if (-not (Test-Path $VenvBaseDir)) {
        New-Item -ItemType Directory -Path $VenvBaseDir -Force | Out-Null
        Write-Host "创建虚拟环境基础目录: $VenvBaseDir" -ForegroundColor $Colors.Green
    }
}

# 创建虚拟环境
function Create-Env {
    param($EnvName, $PythonVer)
    
    if (-not $EnvName) {
        Write-Host "错误: 请提供环境名称" -ForegroundColor $Colors.Red
        exit 1
    }
    
    $EnvPath = Join-Path $VenvBaseDir $EnvName
    
    if (Test-Path $EnvPath) {
        Write-Host "警告: 环境 '$EnvName' 已存在" -ForegroundColor $Colors.Yellow
        $response = Read-Host "是否覆盖? (y/N)"
        if ($response -ne "y" -and $response -ne "Y") {
            return
        }
        Remove-Item -Path $EnvPath -Recurse -Force
    }
    
    Write-Host "创建虚拟环境: $EnvName (使用 $PythonVer)" -ForegroundColor $Colors.Blue
    
    # 使用UV创建环境
    & uv venv $EnvPath --python $PythonVer
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ 虚拟环境 '$EnvName' 创建成功" -ForegroundColor $Colors.Green
        Write-Host "路径: $EnvPath"
        
        # 记录环境信息
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Add-Content -Path "$VenvBaseDir\.env_history" -Value "$timestamp`: 创建环境 $EnvName (Python: $PythonVer)"
    } else {
        Write-Host "错误: 环境创建失败" -ForegroundColor $Colors.Red
    }
}

# 列出所有虚拟环境
function List-Envs {
    Ensure-BaseDir
    
    Write-Host "可用的虚拟环境:" -ForegroundColor $Colors.Blue
    Write-Host ""
    
    $envDirs = Get-ChildItem -Path $VenvBaseDir -Directory -ErrorAction SilentlyContinue
    
    if (-not $envDirs) {
        Write-Host "没有找到虚拟环境" -ForegroundColor $Colors.Yellow
        return
    }
    
    foreach ($envDir in $envDirs) {
        if ($envDir.Name -notlike ".*") {
            $envName = $envDir.Name
            $pythonVersion = ""
            
            $pyvenvCfg = Join-Path $envDir.FullName "pyvenv.cfg"
            if (Test-Path $pyvenvCfg) {
                $versionLine = Get-Content $pyvenvCfg | Where-Object { $_ -match "version" }
                if ($versionLine) {
                    $pythonVersion = ($versionLine -split "=")[1].Trim()
                }
            }
            
            Write-Host "  • $envName - Python $pythonVersion" -ForegroundColor $Colors.Green
            Write-Host "    路径: $($envDir.FullName)"
            Write-Host ""
        }
    }
}

# 删除虚拟环境
function Remove-Env {
    param($EnvName)
    
    if (-not $EnvName) {
        Write-Host "错误: 请提供环境名称" -ForegroundColor $Colors.Red
        exit 1
    }
    
    $EnvPath = Join-Path $VenvBaseDir $EnvName
    
    if (-not (Test-Path $EnvPath)) {
        Write-Host "错误: 环境 '$EnvName' 不存在" -ForegroundColor $Colors.Red
        exit 1
    }
    
    Write-Host "警告: 即将删除环境 '$EnvName'" -ForegroundColor $Colors.Yellow
    Write-Host "路径: $EnvPath"
    $response = Read-Host "确认删除? (y/N)"
    
    if ($response -eq "y" -or $response -eq "Y") {
        Remove-Item -Path $EnvPath -Recurse -Force
        Write-Host "✓ 环境 '$EnvName' 已删除" -ForegroundColor $Colors.Green
    }
}

# 在指定环境中运行命令
function Run-InEnv {
    param($EnvName, $CommandArgs)
    
    if (-not $EnvName) {
        Write-Host "错误: 请提供环境名称" -ForegroundColor $Colors.Red
        exit 1
    }
    
    $EnvPath = Join-Path $VenvBaseDir $EnvName
    
    if (-not (Test-Path $EnvPath)) {
        Write-Host "错误: 环境 '$EnvName' 不存在" -ForegroundColor $Colors.Red
        exit 1
    }
    
    Write-Host "在环境 '$EnvName' 中运行: $($CommandArgs -join ' ')" -ForegroundColor $Colors.Blue
    
    # 设置环境变量并运行命令
    $oldVirtualEnv = $env:VIRTUAL_ENV
    $oldPath = $env:PATH
    
    $env:VIRTUAL_ENV = $EnvPath
    $env:PATH = "$EnvPath\Scripts;$env:PATH"
    
    try {
        if ($CommandArgs.Length -eq 1) {
            & $CommandArgs[0]
        } else {
            & $CommandArgs[0] $CommandArgs[1..($CommandArgs.Length-1)]
        }
    } finally {
        # 恢复原始环境变量
        if ($oldVirtualEnv) {
            $env:VIRTUAL_ENV = $oldVirtualEnv
        } else {
            Remove-Item env:VIRTUAL_ENV -ErrorAction SilentlyContinue
        }
        $env:PATH = $oldPath
    }
}

# 在指定环境中安装包
function Install-InEnv {
    param($EnvName, $Packages)
    
    if (-not $EnvName) {
        Write-Host "错误: 请提供环境名称" -ForegroundColor $Colors.Red
        exit 1
    }
    
    if (-not $Packages) {
        Write-Host "错误: 请提供要安装的包名" -ForegroundColor $Colors.Red
        exit 1
    }
    
    $EnvPath = Join-Path $VenvBaseDir $EnvName
    
    if (-not (Test-Path $EnvPath)) {
        Write-Host "错误: 环境 '$EnvName' 不存在" -ForegroundColor $Colors.Red
        exit 1
    }
    
    Write-Host "在环境 '$EnvName' 中安装包: $($Packages -join ' ')" -ForegroundColor $Colors.Blue
    
    # 使用UV安装包
    $oldVirtualEnv = $env:VIRTUAL_ENV
    $env:VIRTUAL_ENV = $EnvPath
    
    try {
        & uv pip install $Packages
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ 包安装完成" -ForegroundColor $Colors.Green
        } else {
            Write-Host "错误: 包安装失败" -ForegroundColor $Colors.Red
        }
    } finally {
        # 恢复原始环境变量
        if ($oldVirtualEnv) {
            $env:VIRTUAL_ENV = $oldVirtualEnv
        } else {
            Remove-Item env:VIRTUAL_ENV -ErrorAction SilentlyContinue
        }
    }
}

# 显示虚拟环境信息
function Show-EnvInfo {
    param($EnvName)
    
    if (-not $EnvName) {
        Write-Host "错误: 请提供环境名称" -ForegroundColor $Colors.Red
        exit 1
    }
    
    $EnvPath = Join-Path $VenvBaseDir $EnvName
    
    if (-not (Test-Path $EnvPath)) {
        Write-Host "错误: 环境 '$EnvName' 不存在" -ForegroundColor $Colors.Red
        exit 1
    }
    
    Write-Host "虚拟环境信息: $EnvName" -ForegroundColor $Colors.Blue
    Write-Host "======================================" -ForegroundColor $Colors.Blue
    Write-Host ""
    
    # 基本信息
    Write-Host "📁 路径: $EnvPath" -ForegroundColor $Colors.Green
    
    # Python版本信息
    $pyvenvCfg = Join-Path $EnvPath "pyvenv.cfg"
    if (Test-Path $pyvenvCfg) {
        $configContent = Get-Content $pyvenvCfg
        $pythonVersion = ($configContent | Where-Object { $_ -match "version" } | Select-Object -First 1) -replace "version = ", ""
        $pythonHome = ($configContent | Where-Object { $_ -match "home" } | Select-Object -First 1) -replace "home = ", ""
        
        Write-Host "🐍 Python版本: $pythonVersion" -ForegroundColor $Colors.Green
        Write-Host "🏠 Python路径: $pythonHome" -ForegroundColor $Colors.Green
    }
    
    # 环境大小
    try {
        $envSize = (Get-ChildItem -Path $EnvPath -Recurse -File | Measure-Object -Property Length -Sum).Sum
        $envSizeMB = [math]::Round($envSize / 1MB, 2)
        Write-Host "💾 环境大小: $envSizeMB MB" -ForegroundColor $Colors.Green
    } catch {
        Write-Host "💾 环境大小: 无法计算" -ForegroundColor $Colors.Yellow
    }
    
    Write-Host ""
    
    # 已安装的包
    Write-Host "📦 已安装的包:" -ForegroundColor $Colors.Cyan
    
    $oldVirtualEnv = $env:VIRTUAL_ENV
    $env:VIRTUAL_ENV = $EnvPath
    
    try {
        $packages = & uv pip list 2>$null
        if ($packages) {
            $packages | ForEach-Object { Write-Host "  $_" -ForegroundColor $Colors.White }
        } else {
            Write-Host "  (没有安装额外的包)" -ForegroundColor $Colors.Yellow
        }
    } catch {
        Write-Host "  (无法获取包列表)" -ForegroundColor $Colors.Yellow
    } finally {
        if ($oldVirtualEnv) {
            $env:VIRTUAL_ENV = $oldVirtualEnv
        } else {
            Remove-Item env:VIRTUAL_ENV -ErrorAction SilentlyContinue
        }
    }
    
    Write-Host ""
    Write-Host "💡 使用提示:" -ForegroundColor $Colors.Blue
    Write-Host "  激活环境: .\uv-env-manager.ps1 activate $EnvName" -ForegroundColor $Colors.White
    Write-Host "  安装包:   .\uv-env-manager.ps1 install $EnvName <package>" -ForegroundColor $Colors.White
    Write-Host "  运行命令: .\uv-env-manager.ps1 run $EnvName <command>" -ForegroundColor $Colors.White
}

# 生成激活脚本
function Generate-ActivateScript {
    param($EnvName)
    
    $EnvPath = Join-Path $VenvBaseDir $EnvName
    $ActivateScript = "activate-$EnvName.ps1"
    
    $scriptContent = @"
# 激活 $EnvName 虚拟环境

`$env:UV_VENV_PATH = "$EnvPath"
`$env:VIRTUAL_ENV = "$EnvPath"
`$env:PATH = "$EnvPath\Scripts;`$env:PATH"

Write-Host "✓ 已激活虚拟环境: $EnvName" -ForegroundColor Green
Write-Host "路径: $EnvPath"
Write-Host "使用 'deactivate' 命令退出虚拟环境"

function deactivate {
    if (`$env:_OLD_VIRTUAL_PATH) {
        `$env:PATH = `$env:_OLD_VIRTUAL_PATH
        Remove-Item env:_OLD_VIRTUAL_PATH
    }
    
    Remove-Item env:VIRTUAL_ENV -ErrorAction SilentlyContinue
    Remove-Item env:UV_VENV_PATH -ErrorAction SilentlyContinue
    Remove-Item function:deactivate
    
    Write-Host "已退出虚拟环境" -ForegroundColor Yellow
}

# 保存原始PATH
`$env:_OLD_VIRTUAL_PATH = `$env:PATH
"@
    
    Set-Content -Path $ActivateScript -Value $scriptContent
    Write-Host "激活脚本已生成: $ActivateScript" -ForegroundColor $Colors.Blue
    Write-Host "运行 '. .\$ActivateScript' 来激活环境" -ForegroundColor $Colors.Yellow
}

# 主逻辑
Ensure-BaseDir

switch ($Command) {
    "create" { Create-Env $EnvName $PythonVersion }
    "list" { List-Envs }
    "remove" { Remove-Env $EnvName }
    "info" { Show-EnvInfo $EnvName }
    "run" { Run-InEnv $EnvName $RemainingArgs }
    "install" { Install-InEnv $EnvName $RemainingArgs }
    "activate" { Generate-ActivateScript $EnvName }
    "help" { Show-Help }
    default { 
        if (-not $Command) {
            Show-Help
        } else {
            Write-Host "未知命令: $Command" -ForegroundColor $Colors.Red
            Show-Help
        }
    }
}
