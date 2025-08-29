# UV Multi-Environment Manager - 跨平台示例脚本
# 使用方法: .\example_windows.ps1

Write-Host "🚀 UV Multi-Environment Manager - Windows PowerShell 示例" -ForegroundColor Blue
Write-Host "================================================================" -ForegroundColor Blue
Write-Host ""

# 检查系统要求
Write-Host "📋 检查系统要求..." -ForegroundColor Yellow

# 检查PowerShell版本
$psVersion = $PSVersionTable.PSVersion
Write-Host "✓ PowerShell 版本: $psVersion" -ForegroundColor Green

# 检查Python
try {
    $pythonVersion = python --version 2>$null
    Write-Host "✓ Python: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Python 未安装或不在PATH中" -ForegroundColor Red
    Write-Host "请安装Python 3.11+: https://python.org/downloads/" -ForegroundColor Yellow
    exit 1
}

# 检查UV
try {
    $uvVersion = uv --version 2>$null
    Write-Host "✓ UV: $uvVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ UV 未安装" -ForegroundColor Red
    Write-Host "安装UV: irm https://astral.sh/uv/install.ps1 | iex" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "🎯 开始演示 UV 环境管理功能..." -ForegroundColor Blue
Write-Host ""

# 演示1: 创建环境
Write-Host "1️⃣ 创建演示环境 'demo-windows'" -ForegroundColor Cyan
.\uv-env-manager.ps1 create demo-windows python3.12

Write-Host ""
Write-Host "2️⃣ 列出所有环境" -ForegroundColor Cyan
.\uv-env-manager.ps1 list

Write-Host ""
Write-Host "3️⃣ 在环境中安装包" -ForegroundColor Cyan
.\uv-env-manager.ps1 install demo-windows requests numpy

Write-Host ""
Write-Host "4️⃣ 在环境中运行Python代码" -ForegroundColor Cyan
$testCode = @"
import sys
import requests
import numpy as np

print(f'Python版本: {sys.version}')
print(f'Requests版本: {requests.__version__}')
print(f'NumPy版本: {np.__version__}')
print('✅ 所有包导入成功!')

# 简单的功能测试
arr = np.array([1, 2, 3, 4, 5])
print(f'NumPy数组: {arr}')
print(f'数组平均值: {np.mean(arr)}')
"@

$testCode | Out-File -FilePath "test_demo.py" -Encoding UTF8
.\uv-env-manager.ps1 run demo-windows python test_demo.py

Write-Host ""
Write-Host "5️⃣ 生成环境激活脚本" -ForegroundColor Cyan
.\uv-env-manager.ps1 activate demo-windows

Write-Host ""
Write-Host "6️⃣ 演示环境激活" -ForegroundColor Cyan
Write-Host "运行以下命令来激活环境:" -ForegroundColor Yellow
Write-Host ". .\activate-demo-windows.ps1" -ForegroundColor White

# 询问是否要激活环境
$response = Read-Host "是否要激活环境进行交互式演示? (y/N)"
if ($response -eq "y" -or $response -eq "Y") {
    Write-Host "激活环境中..." -ForegroundColor Green
    . .\activate-demo-windows.ps1
    
    Write-Host ""
    Write-Host "🎉 环境已激活! 您现在可以:" -ForegroundColor Green
    Write-Host "  - 运行 python --version 查看Python版本"
    Write-Host "  - 运行 pip list 查看已安装的包"
    Write-Host "  - 运行 python 启动Python解释器"
    Write-Host "  - 运行 deactivate 退出环境"
    Write-Host ""
    
    # 保持PowerShell会话打开
    Write-Host "按任意键继续演示..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

Write-Host ""
Write-Host "7️⃣ 清理演示环境" -ForegroundColor Cyan
$cleanup = Read-Host "是否要删除演示环境? (y/N)"
if ($cleanup -eq "y" -or $cleanup -eq "Y") {
    .\uv-env-manager.ps1 remove demo-windows
    Remove-Item "test_demo.py" -ErrorAction SilentlyContinue
    Remove-Item "activate-demo-windows.ps1" -ErrorAction SilentlyContinue
    Write-Host "✓ 演示环境已清理" -ForegroundColor Green
}

Write-Host ""
Write-Host "🎊 Windows PowerShell 演示完成!" -ForegroundColor Green
Write-Host ""
Write-Host "📚 更多信息:" -ForegroundColor Blue
Write-Host "  - 详细使用指南: WINDOWS-GUIDE.md"
Write-Host "  - 跨平台支持: PLATFORM-SUPPORT.md"
Write-Host "  - 快速参考: QUICK-REFERENCE.md"
Write-Host ""
Write-Host "🚀 开始使用 UV Multi-Environment Manager!" -ForegroundColor Blue
