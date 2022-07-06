#
# Lookup pipeline name(s) in the various trigger json documents
#

function constructPipelineDeployment($targetPipeline) {
    Get-ChildItem $triggerDirectory -Filter *.json |


    Foreach-Object {
        $content = Get-Content $_.FullName
        $jsonContent = $content | ConvertFrom-Json
        $triggerName = $jsonContent.name
        $props = $jsonContent.properties
    
        if ($props.pipelines  | where { $_.pipelineReference.referenceName -eq $targetPipeline }) {
            Write-Host -ForegroundColor Green "$($_.Name) contains $targetPipeline"
            # $triggerArr += $content | ConvertFrom-Json | select name
            Write-Host -ForegroundColor Yellow "Adding trigger: $triggerName to ADF publish options for stop/start"
            $opt.Includes.Add("trigger.$triggerName", "")
        }
        else {
            Write-Debug "$($_.Name) DOES NOT contain $targetPipeline"
        }    
    }
    
    $opt.DoNotStopStartExcludedTriggers = $true
    $opt.DoNotStopStartExcludedTriggers = $true

    return $opt
}
function installAdfDependencies {
    Install-Module Az.DataFactory -MinimumVersion "1.10.0" -Force
    Install-Module -Name "azure.datafactory.tools" -Force
}
try {
    Import-Module -Name "azure.datafactory.tools"
} 
catch {
    installAdfDependencies
}

$triggerDirectory="./root/trigger"
$pipelineDirectory="./root/pipeline"
$manifestDirectory="./manifest"

$rootFolder="root"
$adfName = "sqlplayer-poc"
$adfResourceGroup = "mgb-adf-sandbox"
$location = "eastus"

$triggerArr = @()

$opt = New-AdfPublishOption


$pipeline = Read-Host -Prompt 'Input the target pipeline name (default: "pipeline1")'

if (!$pipeline) {
    $pipeline = "pipeline1"
}

Write-Host "The entered pipeline is" $pipeline -ForegroundColor Green

$opt = constructPipelineDeployment($pipeline)

Publish-AdfV2FromJson -RootFolder "$rootFolder" `
   -ResourceGroupName "$adfResourceGroup" `
   -DataFactoryName "$adfName" `
   -Location "$location" `
   -Option $opt



