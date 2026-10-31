function Get-WinUtilStandardTweakKeys {
    <#

    .SYNOPSIS
        Returns the keys of the tweaks shown on the Standard Tweaks tab, in config order

    .DESCRIPTION
        The suite is every tweaks.json entry in the "Standard Tweaks" category. It is defined once,
        there, so the tab, its buttons and the Tweaks tab all agree on which entries belong to it.

    #>

    @($sync.configs.tweaks.PSObject.Properties | Where-Object { $_.Value.category -eq "Standard Tweaks" } | ForEach-Object { $_.Name })
}
