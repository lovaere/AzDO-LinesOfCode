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

# Calculate lines of code per repository
foreach($repository in $repositories.value){
  Write-Host "Calculating lines of code for $($repository.name)"
  $spaceSafeRepoName = $repository.name -replace " ", "%20"

  git -c http.extraHeader="Authorization: Basic $token" clone $repository.remoteUrl
  cloc "./$($spaceSafeRepoName)" --out "$($spaceSafeRepoName).txt"
  rm -rf "./$($spaceSafeRepoName)"
}

# Make a sum of all the lines of code
$sumCommand = "cloc --sum-reports"
foreach($repository in $repositories.value){
  $spaceSafeRepoName = $repository.name -replace " ", "%20"
  $sumCommand += " $($spaceSafeRepoName).txt"
}
Invoke-Expression -Command $sumCommand

Write-Host "Found $($repositories.count) repositories"