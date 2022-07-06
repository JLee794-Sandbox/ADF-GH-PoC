$rg = "mgb-adf-sandbox"
$adf = "pocsandbox"
$location = "eastus"
$rootFolder = "../root"

$opt = New-AdfPublishOption
$opt.Excludes.Add("*", "testTrigger1")
$opt.DoNotStopStartExcludedTriggers = $true


# return $opt
Publish-AdfV2FromJson -RootFolder $rootFolder -ResourceGroupName $rg -DataFactoryName $adf -Location $location