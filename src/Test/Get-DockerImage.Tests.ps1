#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

param (
    [string] $PSScriptRoot = $( if ( $PSScriptRoot ) { $PSScriptRoot } else { Get-Location } )
)

BeforeAll {
    . $PSScriptRoot\TestHelper.ps1
}

Describe 'Get-DockerImage' {
    Context 'one image of a repository is installed' {
        BeforeAll {
            if ( Get-DockerImage | Where-Object Name -eq $testConfig.Image.Repository ) {
                Uninstall-DockerImage -Name $testConfig.Image.Repository
            }
            Install-DockerImage -Repository $testConfig.Image.Repository
        }

        It 'returns a list of images' {
            Get-DockerImage |
            Where-Object Name -eq $testConfig.Image.Repository | Should -Be
        }

        It 'returns a specific image' {
            (
                Get-DockerImage -Repository $testConfig.Image.Repository -Tag $testConfig.Image.Tag
            ).Repository | Should -Be $testConfig.Image.Repository
        }
    }
}
