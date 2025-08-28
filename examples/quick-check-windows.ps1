# 🪟 Windows 快速验证脚本
# 使用方法: .\quick-check-windows.ps1

Write-Host "🪟 Windows 快速功能验证" -ForegroundColor Blue
Write-Host "=========================" -ForegroundColor Blue
Write-Host ""

$allGood = $true

# 检查函数
function Test-Requirement {
    param($Name, $Command, $ExpectedPattern = $null)
    
    try {
        $result = Invoke-Expression $Command 2>&1
        if ($LASTEXITCODE -eq 0 -and ($ExpectedPattern -eq $null -or $result -match $ExpectedPattern)) {
            Write-Host "✅ $Name - OK" -ForegroundColor Green
            if ($result) {
                Write-Host "   $result" -ForegroundColor Gray
            }
            return $true
        } else {
            Write-Host "❌ $Name - 失败" -ForegroundColor Red
            return $false
        }
    } catch {
        Write-Host "❌ $Name - 错误: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# 1. 基本要求检查
Write-Host "🔍 基本要求检查" -ForegroundColor Cyan
$allGood = (Test-Requirement "PowerShell版本" "`$PSVersionTable.PSVersion") -and $allGood
$allGood = (Test-Requirement "Python安装" "python --version") -and $allGood
$allGood = (Test-Requirement "UV安装" "uv --version") -and $allGood

Write-Host ""

# 2. 脚本文件检查
Write-Host "📁 脚本文件检查" -ForegroundColor Cyan
$requiredFiles = @(
    "uv-env-manager.ps1",
    "example-windows.ps1",
    "WINDOWS-GUIDE.md"
)

foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "✅ $file - 存在" -ForegroundColor Green
    } else {
        Write-Host "❌ $file - 不存在" -ForegroundColor Red
        $allGood = $false
    }
}

Write-Host ""

# 3. 快速功能测试
Write-Host "⚡ 快速功能测试" -ForegroundColor Cyan

# 测试帮助命令
$allGood = (Test-Requirement "帮助命令" ".\uv-env-manager.ps1 help" "使用方法") -and $allGood

# 测试环境列表（即使为空也应该正常工作）
$allGood = (Test-Requirement "环境列表" ".\uv-env-manager.ps1 list") -and $allGood

Write-Host ""

# 4. 权限检查
Write-Host "🔐 权限检查" -ForegroundColor Cyan
$executionPolicy = Get-ExecutionPolicy
Write-Host "执行策略: $executionPolicy"

if ($executionPolicy -eq "Restricted") {
    Write-Host "⚠️ 执行策略受限，可能需要运行:" -ForegroundColor Yellow
    Write-Host "   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor White
} else {
    Write-Host "✅ 执行策略允许脚本运行" -ForegroundColor Green
}

Write-Host ""

# 5. 环境变量检查
Write-Host "🌍 环境变量检查" -ForegroundColor Cyan
$pathDirs = $env:PATH -split ';'
$pythonInPath = $pathDirs | Where-Object { $_ -match "Python" -or $_ -match "Scripts" }
$uvInPath = $pathDirs | Where-Object { $_ -match "uv" -or $_ -match ".local" }

if ($pythonInPath) {
    Write-Host "✅ Python路径在PATH中" -ForegroundColor Green
} else {
    Write-Host "⚠️ Python路径可能不在PATH中" -ForegroundColor Yellow
}

Write-Host ""

# 结果总结
Write-Host "📊 验证结果" -ForegroundColor Blue
Write-Host "============" -ForegroundColor Blue

if ($allGood) {
    Write-Host "🎉 所有检查通过！Windows版本可以正常使用。" -ForegroundColor Green
    Write-Host ""
    Write-Host "🚀 下一步操作:" -ForegroundColor Blue
    Write-Host "1. 运行完整测试: .\test-windows.ps1" -ForegroundColor White
    Write-Host "2. 查看示例演示: .\example-windows.ps1" -ForegroundColor White
    Write-Host "3. 阅读使用指南: WINDOWS-GUIDE.md" -ForegroundColor White
    Write-Host ""
    Write-Host "💡 创建第一个环境:" -ForegroundColor Blue
    Write-Host ".\uv-env-manager.ps1 create myproject python3.12" -ForegroundColor White
} else {
    Write-Host "❌ 发现问题，请检查上述失败项目。" -ForegroundColor Red
    Write-Host ""
    Write-Host "🔧 常见解决方案:" -ForegroundColor Blue
    Write-Host "1. 安装Python: https://python.org/downloads/" -ForegroundColor White
    Write-Host "2. 安装UV: irm https://astral.sh/uv/install.ps1 | iex" -ForegroundColor White
    Write-Host "3. 设置执行策略: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor White
}

Write-Host ""
