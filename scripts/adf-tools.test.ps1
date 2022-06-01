$opt = New-AdfPublishOption
$opt.Excludes.Add("*", "testTrigger1")
$opt.DoNotStopStartExcludedTriggers = $true


# return $opt
Publish-AdfV2FromJson -RootFolder ../ -ResourceGroupName "validation-rg" -DataFactoryName "ghBranchingPoC" -Location "eastus"