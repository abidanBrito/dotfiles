# Description: Batch install my favourite apps.
# Author: Abidán Brito.

# No PowerShell window
$t = '[DllImport("user32.dll")] public static extern bool ShowWindow(int handle, int state);'
Add-Type -name win -member $t -namespace native
[native.win]::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle, 0)

# Check for privileges (elevate if needed)
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    exit
}

# No progress bar (faster runtime)
$ProgressPreference = 'SilentlyContinue'

# Bypass execution policy
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Check for winget & potentially install it
if (Test-Path ~\AppData\Local\Microsoft\WindowsApps\winget.exe) {
    Write-Host "Winget is already installed."
}
else {
    $ComputerInfo = Get-ComputerInfo
    if (((Get-ComputerInfo).WindowsVersion) -lt "1809") {
        Write-Host "Winget is not supported, Windows 1809 or higher is required."
    }
    else {
        Write-Host "Winget not found, installing it now."

        Start-Process "ms-appinstaller:?source=https://aka.ms/getwinget"

        $nid = (Get-Process AppInstaller).Id
        Wait-Process -Id $nid
        Write-Host "Winget installed."
    }
}

# Install apps
$apps = @(
    ### Essentials
    @{ name = "M2Team.NanaZip" },                            # NanaZip
    @{ name = "Brave.Brave" },                               # Brave
    @{ name = "9P3JFR0CLLL6" },                              # MPV
    @{ name = "jurplel.qView" },                             # qView
    @{ name = "SumatraPDF.SumatraPDF" },                     # SumatraPDF
    @{ name = "Flow-Launcher.Flow-Launcher" },               # Flow Launcher
    @{ name = "voidtools.Everything" },                      # Everything
    @{ name = "LGUG2Z.komorebi" },                           # Komorebi
    @{ name = "LGUG2Z.whkd" },                               # whkd
    @{ name = "flux.flux" },                                 # f.lux
    @{ name = "Microsoft.OneDrive" },                        # OneDrive
    @{ name = "Malwarebytes.Malwarebytes" },                 # Malwarebytes
    
    ### Small utils
    @{ name = "SpeedCrunch.SpeedCrunch" },                   # SpeedCrunch
    @{ name = "Greenshot.Greenshot" },                       # Greenshot
    @{ name = "QL-Win.QuickLook" },                          # QuickLook
    @{ name = "Espanso.Espanso" },                           # Espanso
    @{ name = "BleachBit.BleachBit" },                       # Bleachbit
    @{ name = "StefanSundin.Superf4" },                      # SuperF4
    @{ name = "CrystalRich.LockHunter" },                    # LockHunter
    @{ name = "Klocman.BulkCrapUninstaller" },               # BCUninstaller

    ### Development & CLI Tools
    @{ name = "wez.wezterm" },                               # WezTerm
    @{ name = "Nushell.Nushell" },                           # Nushell
    @{ name = "Microsoft.PowerShell" },                      # PowerShell 7
    @{ name = "Starship.Starship" },                         # Starship
    @{ name = "Microsoft.VisualStudioCode" },                # VS Code
    @{ name = "Neovim.Neovim" },                             # Neovim
    @{ name = "Python.Python.3.12" },                        # Python
    @{ name = "MSYS2.MSYS2" },                               # MSYS2
    @{ name = "LLVM.LLVM" },                                 # LLVM
    @{ name = "ajeetdsouza.zoxide" },                        # zoxide
    @{ name = "eza-community.eza" },                         # eza
    @{ name = "sharkdp.bat" },                               # bat
    @{ name = "sharkdp.fd" },                                # fd
    @{ name = "chmln.sd" },                                  # sd - search & displace
    @{ name = "junegunn.fzf" },                              # fzf
    @{ name = "BurntSushi.ripgrep.MSVC" },                   # ripgrep
    @{ name = "Git.Git" },                                   # Git
    @{ name = "Github.cli" },                                # Github CLI
    @{ name = "JesseDuffield.lazygit" },                     # lazygit
    @{ name = "cURL.cURL" },                                 # cURL
    @{ name = "bootandy.dust" },                             # Dust
    @{ name = "dalance.procs" },                             # procs
    @{ name = "gsass1.NTop" },                               # NTop
    @{ name = "tldr-pages.tlrc" },                           # tldr
    @{ name = "XAMPPRocky.Tokei" },                          # tokei
    @{ name = "twpayne.chezmoi" },                           # chezmoi
    @{ name = "sharkdp.hyperfine" },                         # hyperfine
    @{ name = "Genymobile.scrcpy" },                         # scrcpy
    @{ name = "BaldurKarlsson.RenderDoc" },                  # RenderDoc

    ### Misc
    @{ name = "9NBLGGH5R558" },                              # Microsoft To Do
    @{ name = "Spotify.Spotify" },                           # Spotify
    @{ name = "Discord.Discord" },                           # Discord
    @{ name = "Notion.Notion" },                             # Notion
    @{ name = "9NKSQGP7F2NH" },                              # WhatsApp
    @{ name = "LocalSend.LocalSend" },                       # LocalSend
    @{ name = "qBittorrent.qBittorrent" },                   # qBittorrent
    @{ name = "Figma.Figma" },                               # Figma
    @{ name = "darktable.darktable" },                       # Darktable
    @{ name = "OBSProject.OBSStudio" },                      # OBS Studio
    # @{ name = "OpenShot.OpenShot" },                         # OpenShot
    @{ name = "Gyan.FFmpeg" },                               # FFmpeg
);

foreach ($app in $apps) {
    $listApp = winget list --exact -q $app.name
    if (![String]::Join("", $listApp).Contains($app.name)) {
        Write-Host "Installing: " $app.name
        winget install -e -h --accept-source-agreements --accept-package-agreements --id $app.name 
    }
    else {
        Write-Host "Skipping: " $app.name " (already installed)"
    }
}
