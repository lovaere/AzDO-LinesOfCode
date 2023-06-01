# AzDO-LinesOfCode
Count the total lines of code in an Azure DevOps project. This tool will investigate all the git repositories of an Azure DevOps project and count the lines of code with [cloc](https://github.com/AlDanial/cloc).

## Requirements
This tool is written in PowerShell but makes use of:
- [git](https://git-scm.com/)
- [cloc](https://github.com/AlDanial/cloc)

The script assume both tools are available.

## Azure DevOps API - PAT token
The script uses the Azure DevOps API to fetch all the repositories in your project. Therefore it requires a PAT token that has read access to your code. No other privileges are required.

## Run the script
```ps
# Install git https://git-scm.com/ or another option
# Install cloc:
npm install -g cloc  # other options are available, check the GitHub page of cloc

# Run the script:
.\Get-LinesOfCodeOverview.ps1 -OrganizationName MyOrg -ProjectName MyProject -PatToken MyPatToken
```