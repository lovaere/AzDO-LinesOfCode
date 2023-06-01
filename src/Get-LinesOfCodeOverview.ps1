<#
.SYNOPSIS
  Get-LinesOfCodeOverview

.DESCRIPTION
  This script can be used to count the total lines of code in all git repositories of a DevOps project

.PARAMETER OrganizationName
  The name of your DevOps organization. Required to fetch the repositories that are part of your project.

.PARAMETER ProjectName
  Project name inside DevOps that will be scanned.

.PARAMETER PatToken
  Personal Access Token (PAT) that has read access to your repositories. Required to fetch the repositories that are part of your project.

.OUTPUTS
  Overview of the total lines of code in all git repositories of your DevOps project

.NOTES
  Version:        1.0
  Author:         Laurenz Ovaere
  Creation Date:  01/06/2023
  
.EXAMPLE
  .\Get-LinesOfCodeOverview.ps1 --OrganizationName MyOrg --ProjectName MyProject --PatToken MyPatToken
#>

param(

    [Parameter()]
    [string]$OrganizationName,

    [Parameter()]
    [string]$ProjectName,    

    [Parameter()]
    [string]$PatToken
)

# Start script
Write-Host "Start lines of code calculation for $ProjectName in $OrganizationName"

# Set header with PAT token
$token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($PatToken)"))
$header = @{Authorization = "Basic $token"}

# Get all repositories
$baseUrl = "https://dev.azure.com/$OrganizationName/$ProjectName/_apis/git/repositories?api-version=6.0"
$repositories = Invoke-RestMethod -Uri $baseUrl -Method Get -Headers $header

Write-Host "Found $($repositories.count) repositories"