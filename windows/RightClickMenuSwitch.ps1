# 设置控制台输出为UTF-8，以确保正确显示中文字符
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host ""
Write-Host "============================================="
Write-Host "右键菜单类型"
Write-Host "1 (Win10旧版右键菜单)"
Write-Host "2 (Win11新版右键菜单)"
Write-Host "============================================="



# 定义一个循环以确保用户输入有效的选项
do {
    $opt = Read-Host "请选择操作"
    switch ($opt) {
        "1" {
            Write-Host "正在开启Win10旧版右键菜单》》》》》》》》》"
            try {
                & reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
                Write-Host "成功设置Win10旧版右键菜单。"
            } catch {
                Write-Host "设置Win10旧版右键菜单时出错：$_"
            }
            break
        }
        "2" {
            Write-Host "正在恢复Win11新版右键菜单》》》》》》》》》"
            try {
                Remove-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Recurse -Force
                Write-Host "成功恢复Win11新版右键菜单。"
            } catch {
                Write-Host "恢复Win11新版右键菜单时出错：$_"
            }
            break
        }
        default {
            Write-Host "无效的选择，请输入1或2。"
        }
    }
} while ($opt -ne "1" -and $opt -ne "2")

Write-Host "操作完成。"

# 重启资源管理器
try {
    Stop-Process -Name explorer -Force
    Start-Process explorer.exe
    Write-Host "资源管理器已重启。"
} catch {
    Write-Host "重启资源管理器时出错：$_"
}
