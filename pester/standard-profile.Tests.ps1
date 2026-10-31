#===========================================================================
# Tests - MejorarWindows Standard profile (presets, Standard Tweaks tab, power plan)

BeforeAll {
    $script:repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
    $script:configRoot = Join-Path $script:repoRoot "config"

    . (Join-Path $script:repoRoot "functions\private\Get-WinUtilStandardTweakKeys.ps1")
    . (Join-Path $script:repoRoot "functions\public\Invoke-WPFButton.ps1")
    . (Join-Path $script:repoRoot "functions\private\Measure-WinUtilStep.ps1")
    . (Join-Path $script:repoRoot "functions\private\Initialize-WinUtilTabContent.ps1")

    function Step-WinUtilJob {
        param([string]$Status, [int]$Percent, [string]$State, [string]$Overlay, [switch]$Hide)
    }
    function Write-WinUtilLog {
        param($Message, $Level, $Component)
    }
    function Invoke-WPFtweaksbutton {
        param([string[]]$Tweaks, [switch]$SkipDns)
    }
    function Invoke-WPFundoall {
        param([string[]]$Tweaks)
    }
    function Invoke-WPFUIElements {
        param($configVariable, [string]$targetGridName, [int]$columncount, [switch]$Yield)
    }
    function Reset-WPFCheckBoxes { param([bool]$doToggles) }

    function script:Get-WinUtilConfigObject {
        param([string]$Name)

        Get-Content -Path (Join-Path $script:configRoot "$Name.json") -Raw | ConvertFrom-Json
    }

    # Stands in for powercfg.exe. Copying a scheme gives the copy a new random GUID, like the real one.
    function powercfg {
        $global:LASTEXITCODE = 0
        $target = $args[1]
        switch ($args[0]) {
            "/list" {
                foreach ($plan in $script:powerPlans) {
                    "Power Scheme GUID: $($plan.Guid)  ($($plan.Name))"
                }
            }
            "/duplicatescheme" {
                $newGuid = [guid]::NewGuid().ToString()
                $script:powerPlans.Add([pscustomobject]@{ Guid = $newGuid; Name = "Ultimate Performance" })
                "Power Scheme GUID: $newGuid  (Ultimate Performance)"
            }
            "/changename" {
                ($script:powerPlans | Where-Object { $_.Guid -eq $target }).Name = $args[2]
            }
            "/setactive" {
                $script:activePowerPlan = $target
            }
            "/delete" {
                $plan = $script:powerPlans | Where-Object { $_.Guid -eq $target }
                [void]$script:powerPlans.Remove($plan)
            }
        }
    }
}

Describe "Standard and Office presets" {
    It "create a restore point before any other change" {
        $preset = Get-WinUtilConfigObject -Name "preset"

        foreach ($presetName in @("Standard", "Office")) {
            @($preset.$presetName)[0] | Should -Be "WPFTweaksRestorePoint" -Because "the $presetName preset changes services, policies and the boot configuration"
        }
    }

    It "do not apply the same change twice" {
        # Activity History is covered by the privacy suite, which it would partly undo by running
        # after it, and the temp folders are already emptied by the Storage Sense tweak
        $preset = Get-WinUtilConfigObject -Name "preset"

        foreach ($presetName in @("Standard", "Office")) {
            foreach ($redundant in @("WPFTweaksActivity", "WPFTweaksDeleteTempFiles", "WPFTweaksDiskCleanup")) {
                @($preset.$presetName) | Should -Not -Contain $redundant -Because "$presetName already covers what $redundant does"
            }
        }
    }

    It "do not write one registry value twice with different data" {
        # The run order follows the selection, not the preset, so the last write would be arbitrary
        $preset = Get-WinUtilConfigObject -Name "preset"
        $tweaks = Get-WinUtilConfigObject -Name "tweaks"

        foreach ($presetName in @("Standard", "Office")) {
            $claims = @{}
            foreach ($tweakName in @($preset.$presetName)) {
                foreach ($registryEntry in @($tweaks.$tweakName.registry)) {
                    if ($null -eq $registryEntry -or $registryEntry.Values) { continue }

                    $key = "$($registryEntry.Path)|$($registryEntry.Name)"
                    if (-not $claims.ContainsKey($key)) {
                        $claims[$key] = @{}
                    }
                    $claims[$key][$tweakName] = [string]$registryEntry.Value
                }
            }

            $conflicts = @(
                foreach ($key in $claims.Keys) {
                    if (@($claims[$key].Values | Select-Object -Unique).Count -gt 1) {
                        "${presetName}: $key = " + (($claims[$key].GetEnumerator() | Sort-Object Key | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join ", ")
                    }
                }
            )
            $conflicts | Should -BeNullOrEmpty
        }
    }

    It "leave the Ultimate Performance plan out of Standard" {
        # The plan keeps the CPU at full clocks, which on a laptop costs battery and heat
        $preset = Get-WinUtilConfigObject -Name "preset"

        @($preset.Standard) | Should -Not -Contain "WPFTweaksUltimatePerformance"
    }
}

Describe "Tweak service entries" {
    It "change the startup type they claim to change" {
        # An entry whose startup type equals its original never changes anything
        $tweaks = Get-WinUtilConfigObject -Name "tweaks"
        $noOps = @(
            foreach ($tweak in $tweaks.PSObject.Properties) {
                foreach ($service in @($tweak.Value.service)) {
                    if ($null -ne $service -and $service.StartupType -eq $service.OriginalType) {
                        "$($tweak.Name): $($service.Name) $($service.StartupType)"
                    }
                }
            }
        )

        $noOps | Should -BeNullOrEmpty
    }
}

Describe "Selectable config keys" {
    It "are defined in one config file only" {
        # Two entries under one key build two controls with the same name, and $sync keeps one
        $owners = @{}
        # Every config file except the ones that only reference keys or hold no controls
        $configNames = Get-ChildItem -Path $script:configRoot -Filter *.json |
            Where-Object { $_.BaseName -notin @("preset", "themes", "dns", "appnavigation") } |
            ForEach-Object { $_.BaseName }
        foreach ($configName in $configNames) {
            $config = Get-WinUtilConfigObject -Name $configName
            foreach ($name in $config.PSObject.Properties.Name) {
                $key = if ($configName -eq "applications") { "WPFInstall$name" } else { $name }
                if (-not $owners.ContainsKey($key)) {
                    $owners[$key] = [System.Collections.Generic.List[string]]::new()
                }
                $owners[$key].Add($configName)
            }
        }

        $duplicates = @($owners.GetEnumerator() | Where-Object { $_.Value.Count -gt 1 } | ForEach-Object { "$($_.Key): $($_.Value -join ', ')" })
        if ($duplicates.Count -gt 0) {
            throw ($duplicates -join "`n")
        }
    }

    It "put the 13 Standard profile tweaks, and only those, in the Standard Tweaks category" {
        $tweaks = Get-WinUtilConfigObject -Name "tweaks"
        $suite = @($tweaks.PSObject.Properties | Where-Object { $_.Value.category -eq "Standard Tweaks" } | ForEach-Object { $_.Name })

        $suite | Should -Be @(
            "WPFTweaksServices", "WPFTweaksDVR", "WPFTweaksGameModeAndHAGS", "WPFTweaksDisableNotificationsAndTips",
            "WPFTweaksDisableTransparency", "WPFTweaksBackgroundApps", "WPFTweaksPrivacySuite",
            "WPFTweaksDeliveryOptimization", "WPFTweaksVisualFXPerformance", "WPFTweaksMouseAcceleration",
            "WPFTweaksUltimatePerformance", "WPFTweaksFastBootTime", "WPFTweaksStorageAndTempCleanup"
        )
    }

    It "leave no standalone copy of the Standard Tweaks suite" {
        Join-Path $script:configRoot "standardtweaks.json" | Should -Not -Exist
    }
}

Describe "Standard Tweaks tab" {
    BeforeEach {
        $script:sync = [Hashtable]::Synchronized(@{
            ActiveJob = $null
            selectedTweaks = [System.Collections.Generic.List[string]]::new()
            configs = @{
                feature = [pscustomobject]@{}
                tweaks = [pscustomobject]@{
                    WPFTweaksRestorePoint = [pscustomobject]@{ Content = "Restore Point"; category = "Essential Tweaks" }
                    WPFTweaksDVR = [pscustomobject]@{ Content = "Disable GameDVR"; category = "Standard Tweaks" }
                    WPFTweaksServices = [pscustomobject]@{ Content = "Services"; category = "Standard Tweaks" }
                }
            }
        })

        Mock Step-WinUtilJob { }
        Mock Invoke-WPFtweaksbutton { }
        Mock Invoke-WPFundoall { }
        Mock Invoke-WPFUIElements { }
        Mock Reset-WPFCheckBoxes { }
    }

    AfterEach {
        Remove-Variable -Name sync -Scope Script -ErrorAction SilentlyContinue
    }

    It "lists the tweaks.json entries in the Standard Tweaks category" {
        Get-WinUtilStandardTweakKeys | Should -Be @("WPFTweaksDVR", "WPFTweaksServices")
    }

    It "builds the suite on its own tab and leaves it off the Tweaks tab" {
        Initialize-WinUtilTabContent -TabName "Tweaks"
        Initialize-WinUtilTabContent -TabName "StandardTweaks"

        Should -Invoke Invoke-WPFUIElements -Times 1 -Exactly -ParameterFilter {
            $targetGridName -eq "tweakspanel" -and
                (@($configVariable.PSObject.Properties.Name) -join ",") -eq "WPFTweaksRestorePoint"
        }
        Should -Invoke Invoke-WPFUIElements -Times 1 -Exactly -ParameterFilter {
            $targetGridName -eq "standardtweakspanel" -and
                (@($configVariable.PSObject.Properties.Name) -join ",") -eq "WPFTweaksDVR,WPFTweaksServices"
        }
    }

    It "runs only the checked tweaks that belong to the suite, without DNS" {
        $script:sync.selectedTweaks.Add("WPFTweaksRestorePoint")
        $script:sync.selectedTweaks.Add("WPFTweaksServices")

        Invoke-WPFButton -Button "WPFRunStandardTweaks"

        Should -Invoke Invoke-WPFtweaksbutton -Times 1 -Exactly -ParameterFilter {
            $SkipDns -and (@($Tweaks) -join ",") -eq "WPFTweaksServices"
        }
    }

    It "undoes only the checked tweaks that belong to the suite" {
        $script:sync.selectedTweaks.Add("WPFTweaksRestorePoint")
        $script:sync.selectedTweaks.Add("WPFTweaksDVR")

        Invoke-WPFButton -Button "WPFUndoStandardTweaks"

        Should -Invoke Invoke-WPFundoall -Times 1 -Exactly -ParameterFilter {
            (@($Tweaks) -join ",") -eq "WPFTweaksDVR"
        }
    }
}

Describe "run.ps1 launcher" {
    BeforeAll {
        $script:runScriptPath = Join-Path $script:repoRoot "run.ps1"
        $script:runScript = Get-Content -Path $script:runScriptPath -Raw
    }

    It "never picks winutil.ps1 from the current folder" {
        # Piped through iex the current folder is wherever the console happens to be, so only the
        # script's own folder may supply a local copy
        $script:runScript | Should -Not -Match 'Get-Location|\$PWD|\(Get-Item \.\)'
        $script:runScript | Should -Match '\$PSCommandPath'
    }

    It "relaunches a local copy from disk instead of downloading it" {
        $script:runScript | Should -Match ([regex]::Escape('''-File'', "`"$PSCommandPath`""'))
    }

    It "is plain ASCII so Windows PowerShell 5.1 reads it unchanged" {
        $bytes = [System.IO.File]::ReadAllBytes($script:runScriptPath)
        @($bytes | Where-Object { $_ -gt 127 }) | Should -BeNullOrEmpty
    }
}

Describe "Ultimate Performance tweak" {
    BeforeEach {
        $script:powerPlans = [System.Collections.Generic.List[object]]::new()
        $script:powerPlans.Add([pscustomobject]@{ Guid = "381b4222-f694-41f0-9685-ff5bb260df2e"; Name = "Balanced" })
        $script:powerPlans.Add([pscustomobject]@{ Guid = "a1841308-3541-4fab-bc81-f71556f20b4a"; Name = "Power saver" })
        $script:activePowerPlan = "381b4222-f694-41f0-9685-ff5bb260df2e"

        $tweak = (Get-WinUtilConfigObject -Name "tweaks").WPFTweaksUltimatePerformance
        $script:applyScripts = @($tweak.InvokeScript | ForEach-Object { [scriptblock]::Create($_) })
        $script:undoScripts = @($tweak.UndoScript | ForEach-Object { [scriptblock]::Create($_) })
    }

    It "activates one copy of the plan however many times it is applied" {
        foreach ($run in 1..3) {
            $script:applyScripts | ForEach-Object { & $_ }
        }

        $copies = @($script:powerPlans | Where-Object { $_.Name -eq "MejorarWindows Ultimate Performance" })
        $copies | Should -HaveCount 1
        $script:activePowerPlan | Should -Be $copies[0].Guid
    }

    It "removes its copy and goes back to Balanced on undo" {
        $script:applyScripts | ForEach-Object { & $_ }
        $script:undoScripts | ForEach-Object { & $_ }

        @($script:powerPlans | Where-Object { $_.Name -eq "MejorarWindows Ultimate Performance" }) | Should -HaveCount 0
        $script:activePowerPlan | Should -Be "381b4222-f694-41f0-9685-ff5bb260df2e"
        $script:powerPlans | Should -HaveCount 2
    }
}
