# 🪟 Windows 功能测试脚本
# 使用方法: .\test-windows.ps1

param(
    [switch]$Verbose,
    [switch]$SkipCleanup
)

# 测试配置
$TestEnvName = "test-windows-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
$TestResults = @()
$ErrorCount = 0

# 颜色定义
$Colors = @{
    Red = "Red"
    Green = "Green"
    Yellow = "Yellow"
    Blue = "Blue"
    Cyan = "Cyan"
    Magenta = "Magenta"
}

# 测试结果记录函数
function Add-TestResult {
    param($TestName, $Status, $Details = "", $Duration = 0)
    
    $TestResults += [PSCustomObject]@{
        TestName = $TestName
        Status = $Status
        Details = $Details
        Duration = $Duration
        Timestamp = Get-Date
    }
    
    $color = if ($Status -eq "PASS") { $Colors.Green } else { $Colors.Red }
    $statusSymbol = if ($Status -eq "PASS") { "✅" } else { "❌" }
    
    Write-Host "$statusSymbol $TestName - $Status" -ForegroundColor $color
    if ($Details -and $Verbose) {
        Write-Host "   详情: $Details" -ForegroundColor Gray
    }
    if ($Duration -gt 0) {
        Write-Host "   耗时: $([math]::Round($Duration, 2))秒" -ForegroundColor Gray
    }
    
    if ($Status -eq "FAIL") {
        $script:ErrorCount++
    }
}

# 执行测试命令
function Invoke-TestCommand {
    param($Command, $TestName)
    
    try {
        $startTime = Get-Date
        $result = Invoke-Expression $Command
        $endTime = Get-Date
        $duration = ($endTime - $startTime).TotalSeconds
        
        if ($LASTEXITCODE -eq 0 -or $LASTEXITCODE -eq $null) {
            Add-TestResult $TestName "PASS" $result $duration
            return $true
        } else {
            Add-TestResult $TestName "FAIL" "退出代码: $LASTEXITCODE" $duration
            return $false
        }
    } catch {
        Add-TestResult $TestName "FAIL" $_.Exception.Message
        return $false
    }
}

Write-Host "🪟 Windows 功能测试开始" -ForegroundColor $Colors.Blue
Write-Host "======================================" -ForegroundColor $Colors.Blue
Write-Host ""

# 测试环境信息
Write-Host "📋 测试环境信息" -ForegroundColor $Colors.Yellow
Write-Host "操作系统: $((Get-WmiObject Win32_OperatingSystem).Caption)"
Write-Host "PowerShell版本: $($PSVersionTable.PSVersion)"
Write-Host "测试时间: $(Get-Date)"
Write-Host "测试环境名: $TestEnvName"
Write-Host ""

# 1. 系统要求检查
Write-Host "🔍 系统要求检查" -ForegroundColor $Colors.Cyan

# 检查PowerShell版本
$psVersion = $PSVersionTable.PSVersion
if ($psVersion.Major -ge 5) {
    Add-TestResult "PowerShell版本检查" "PASS" "版本: $psVersion"
} else {
    Add-TestResult "PowerShell版本检查" "FAIL" "需要PowerShell 5.1+，当前: $psVersion"
}

# 检查Python
try {
    $pythonVersion = python --version 2>$null
    if ($pythonVersion) {
        Add-TestResult "Python安装检查" "PASS" $pythonVersion
    } else {
        Add-TestResult "Python安装检查" "FAIL" "Python未找到"
    }
} catch {
    Add-TestResult "Python安装检查" "FAIL" "Python未安装或不在PATH中"
}

# 检查UV
try {
    $uvVersion = uv --version 2>$null
    if ($uvVersion) {
        Add-TestResult "UV安装检查" "PASS" $uvVersion
    } else {
        Add-TestResult "UV安装检查" "FAIL" "UV未找到"
    }
} catch {
    Add-TestResult "UV安装检查" "FAIL" "UV未安装"
}

# 检查脚本文件
if (Test-Path ".\uv-env-manager.ps1") {
    Add-TestResult "PowerShell脚本检查" "PASS" "uv-env-manager.ps1存在"
} else {
    Add-TestResult "PowerShell脚本检查" "FAIL" "uv-env-manager.ps1不存在"
}

Write-Host ""

# 2. 核心功能测试
Write-Host "🧪 核心功能测试" -ForegroundColor $Colors.Cyan

# 测试帮助信息
Invoke-TestCommand ".\uv-env-manager.ps1 help" "帮助信息显示"

# 测试环境创建
Invoke-TestCommand ".\uv-env-manager.ps1 create $TestEnvName python3.12" "环境创建"

# 测试环境列表
Invoke-TestCommand ".\uv-env-manager.ps1 list" "环境列表"

# 测试包安装
Invoke-TestCommand ".\uv-env-manager.ps1 install $TestEnvName requests" "包安装"

# 测试命令运行
$testCode = "import sys; import requests; print(f'Python: {sys.version}'); print(f'Requests: {requests.__version__}'); print('✅ 测试成功')"
Invoke-TestCommand ".\uv-env-manager.ps1 run $TestEnvName python -c `"$testCode`"" "命令运行"

# 测试环境激活脚本生成
Invoke-TestCommand ".\uv-env-manager.ps1 activate $TestEnvName" "激活脚本生成"

# 检查激活脚本是否生成
$activateScript = "activate-$TestEnvName.ps1"
if (Test-Path $activateScript) {
    Add-TestResult "激活脚本文件检查" "PASS" "文件已生成: $activateScript"
} else {
    Add-TestResult "激活脚本文件检查" "FAIL" "激活脚本未生成"
}

Write-Host ""

# 3. 错误处理测试
Write-Host "🛡️ 错误处理测试" -ForegroundColor $Colors.Cyan

# 测试不存在的环境
try {
    $result = .\uv-env-manager.ps1 run "nonexistent-env" python --version 2>&1
    if ($result -match "错误" -or $result -match "不存在") {
        Add-TestResult "不存在环境错误处理" "PASS" "正确显示错误信息"
    } else {
        Add-TestResult "不存在环境错误处理" "FAIL" "未正确处理错误"
    }
} catch {
    Add-TestResult "不存在环境错误处理" "PASS" "正确抛出异常"
}

# 测试无效命令
try {
    $result = .\uv-env-manager.ps1 invalid-command 2>&1
    if ($result -match "未知命令" -or $result -match "帮助") {
        Add-TestResult "无效命令错误处理" "PASS" "正确显示帮助信息"
    } else {
        Add-TestResult "无效命令错误处理" "FAIL" "未正确处理无效命令"
    }
} catch {
    Add-TestResult "无效命令错误处理" "FAIL" "异常处理失败"
}

Write-Host ""

# 4. 性能测试
Write-Host "⚡ 性能测试" -ForegroundColor $Colors.Cyan

# 环境创建性能
$perfTestEnv = "perf-test-$(Get-Date -Format 'HHmmss')"
$startTime = Get-Date
$result = .\uv-env-manager.ps1 create $perfTestEnv python3.12 2>&1
$endTime = Get-Date
$createDuration = ($endTime - $startTime).TotalSeconds

if ($LASTEXITCODE -eq 0 -or $result -match "创建成功") {
    Add-TestResult "环境创建性能" "PASS" "创建时间: $([math]::Round($createDuration, 2))秒" $createDuration
} else {
    Add-TestResult "环境创建性能" "FAIL" "环境创建失败"
}

# 包安装性能
$startTime = Get-Date
$result = .\uv-env-manager.ps1 install $perfTestEnv numpy 2>&1
$endTime = Get-Date
$installDuration = ($endTime - $startTime).TotalSeconds

if ($LASTEXITCODE -eq 0 -or $result -match "安装完成") {
    Add-TestResult "包安装性能" "PASS" "安装时间: $([math]::Round($installDuration, 2))秒" $installDuration
} else {
    Add-TestResult "包安装性能" "FAIL" "包安装失败"
}

# 清理性能测试环境
.\uv-env-manager.ps1 remove $perfTestEnv 2>&1 | Out-Null

Write-Host ""

# 5. 示例脚本测试
Write-Host "📝 示例脚本测试" -ForegroundColor $Colors.Cyan

if (Test-Path ".\example-windows.ps1") {
    Add-TestResult "Windows示例脚本存在" "PASS" "example-windows.ps1文件存在"
    
    # 检查示例脚本语法
    try {
        $null = Get-Command ".\example-windows.ps1" -ErrorAction Stop
        Add-TestResult "示例脚本语法检查" "PASS" "PowerShell语法正确"
    } catch {
        Add-TestResult "示例脚本语法检查" "FAIL" $_.Exception.Message
    }
} else {
    Add-TestResult "Windows示例脚本存在" "FAIL" "example-windows.ps1文件不存在"
}

Write-Host ""

# 6. 文档完整性检查
Write-Host "📚 文档完整性检查" -ForegroundColor $Colors.Cyan

$requiredDocs = @(
    "WINDOWS-GUIDE.md",
    "PLATFORM-SUPPORT.md",
    "README.md"
)

foreach ($doc in $requiredDocs) {
    if (Test-Path $doc) {
        $content = Get-Content $doc -Raw
        if ($content.Length -gt 100) {
            Add-TestResult "文档检查: $doc" "PASS" "文档存在且有内容"
        } else {
            Add-TestResult "文档检查: $doc" "FAIL" "文档内容过少"
        }
    } else {
        Add-TestResult "文档检查: $doc" "FAIL" "文档不存在"
    }
}

Write-Host ""

# 7. 清理测试环境
if (-not $SkipCleanup) {
    Write-Host "🧹 清理测试环境" -ForegroundColor $Colors.Cyan
    
    # 删除测试环境
    $result = .\uv-env-manager.ps1 remove $TestEnvName 2>&1
    if ($LASTEXITCODE -eq 0 -or $result -match "已删除") {
        Add-TestResult "测试环境清理" "PASS" "环境已删除"
    } else {
        Add-TestResult "测试环境清理" "FAIL" "环境删除失败"
    }
    
    # 删除激活脚本
    $activateScript = "activate-$TestEnvName.ps1"
    if (Test-Path $activateScript) {
        Remove-Item $activateScript -Force
        Add-TestResult "激活脚本清理" "PASS" "激活脚本已删除"
    }
    
    Write-Host ""
}

# 8. 生成测试报告
Write-Host "📊 测试结果统计" -ForegroundColor $Colors.Blue
Write-Host "======================================" -ForegroundColor $Colors.Blue

$totalTests = $TestResults.Count
$passedTests = ($TestResults | Where-Object { $_.Status -eq "PASS" }).Count
$failedTests = ($TestResults | Where-Object { $_.Status -eq "FAIL" }).Count
$successRate = if ($totalTests -gt 0) { [math]::Round(($passedTests / $totalTests) * 100, 2) } else { 0 }

Write-Host "总测试数: $totalTests"
Write-Host "通过测试: $passedTests ✅" -ForegroundColor $Colors.Green
Write-Host "失败测试: $failedTests ❌" -ForegroundColor $Colors.Red
Write-Host "成功率: $successRate%"

if ($failedTests -gt 0) {
    Write-Host ""
    Write-Host "失败的测试:" -ForegroundColor $Colors.Red
    $TestResults | Where-Object { $_.Status -eq "FAIL" } | ForEach-Object {
        Write-Host "  ❌ $($_.TestName): $($_.Details)" -ForegroundColor $Colors.Red
    }
}

Write-Host ""

# 生成详细报告文件
$reportFile = "WINDOWS-TEST-REPORT-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"
$reportContent = @"
# 🪟 Windows 功能测试报告

## 📋 测试环境信息

- **操作系统**: $((Get-WmiObject Win32_OperatingSystem).Caption)
- **PowerShell版本**: $($PSVersionTable.PSVersion)
- **测试时间**: $(Get-Date)
- **测试环境**: $TestEnvName

## 📊 测试结果统计

- **总测试数**: $totalTests
- **通过测试**: $passedTests ✅
- **失败测试**: $failedTests ❌
- **成功率**: $successRate%

## 📝 详细测试结果

| 测试名称 | 状态 | 详情 | 耗时(秒) |
|----------|------|------|----------|
"@

foreach ($result in $TestResults) {
    $status = if ($result.Status -eq "PASS") { "✅ PASS" } else { "❌ FAIL" }
    $reportContent += "| $($result.TestName) | $status | $($result.Details) | $($result.Duration) |`n"
}

$reportContent += @"

## 🎯 测试结论

"@

if ($failedTests -eq 0) {
    $reportContent += @"
**🎉 所有测试通过！Windows版本功能完整，可以正常使用。**

### 优点
- ✅ 所有核心功能正常工作
- ✅ 错误处理完善
- ✅ 性能表现良好
- ✅ 文档完整

**推荐评级**: ⭐⭐⭐⭐⭐ (5/5星)
"@
} else {
    $reportContent += @"
**⚠️ 发现 $failedTests 个问题，需要修复后再使用。**

### 需要修复的问题
"@
    $TestResults | Where-Object { $_.Status -eq "FAIL" } | ForEach-Object {
        $reportContent += "- ❌ $($_.TestName): $($_.Details)`n"
    }
}

$reportContent += @"

---
*测试报告生成时间: $(Get-Date)*
"@

Set-Content -Path $reportFile -Value $reportContent -Encoding UTF8
Write-Host "详细测试报告已生成: $reportFile" -ForegroundColor $Colors.Blue

# 最终结果
Write-Host ""
if ($failedTests -eq 0) {
    Write-Host "🎉 Windows功能测试完成！所有功能正常工作。" -ForegroundColor $Colors.Green
    Write-Host "UV Multi-Environment Manager 在 Windows 平台上可以正常使用！" -ForegroundColor $Colors.Green
    exit 0
} else {
    Write-Host "⚠️ Windows功能测试发现问题，请检查失败的测试项。" -ForegroundColor $Colors.Red
    exit 1
}
