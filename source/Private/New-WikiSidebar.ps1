<#
    .SYNOPSIS
        Creates the Wiki side bar file from the list of markdown files in the path.

    .DESCRIPTION
        Creates the Wiki side bar file from the list of markdown files in the path.

    .PARAMETER ModuleName
        The name of the module to generate a new Wiki Sidebar file for.

    .PARAMETER Path
        The path to both create the Wiki Sidebar file and where to find the
        markdown files that was generated by New-DscResourceWikiPage, e.g.
        '.\output\WikiContent'.

    .PARAMETER BaseName
        The base name of the Wiki Sidebar file. Defaults to '_Sidebar.md'.

    .EXAMPLE
        New-WikiSidebar -ModuleName 'ActiveDirectoryDsc -Path '.\output\WikiContent'

        Creates the Wiki side bar from the list of markdown files in the path.
#>
function New-WikiSidebar
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ModuleName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [Parameter()]
        [System.String]
        $BaseName = '_Sidebar.md'
    )

    $wikiSideBarPath = Join-Path -Path $Path -ChildPath $BaseName

    if (-not (Test-Path -Path $wikiSideBarPath))
    {
        Write-Verbose -Message ($localizedData.GenerateWikiSidebarMessage -f $BaseName)

        $WikiSidebarContent = @(
            "# $ModuleName Module"
            ' '
        )

        $wikiFiles = Get-ChildItem -Path (Join-Path -Path $Path -ChildPath '*.md') -Exclude '_*.md'

        foreach ($file in $wikiFiles)
        {
            Write-Verbose -Message ("`t{0}" -f ($localizedData.AddFileToSideBar -f $file.Name))

            $WikiSidebarContent += "- [$($file.BaseName)]($($file.BaseName))"
        }

        Out-File -InputObject $WikiSidebarContent -FilePath $wikiSideBarPath -Encoding 'ascii'
    }
}
