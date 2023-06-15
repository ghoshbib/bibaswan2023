<#
 .SYNOPSIS
    Deploys a template to Azure

 .DESCRIPTION
    Deploys an Azure Resource Manager template

 .PARAMETER subscriptionId
    The subscription id where the template will be deployed.

 .PARAMETER resourceGroupName
    The resource group where the template will be deployed. Can be the name of an existing or a new resource group.

 .PARAMETER resourceGroupLocation
    Optional, a resource group location. If specified, will try to create a new resource group in this location. If not specified, assumes resource group is existing.

 .PARAMETER deploymentName
    The deployment name.

 .PARAMETER templateFilePath
    Optional, path to the template file. Defaults to template.json.

 .PARAMETER parametersFilePath
    Optional, path to the parameters file. Defaults to parameters.json. If file is not found, will prompt for parameter values based on template.
#>

param(
 [Parameter(Mandatory=$True)]
 [string]
 $subscriptionId,

 [Parameter(Mandatory=$True)]
 [string]
 $resourceGroupName,

 [Parameter(Mandatory=$True)]
 [string]
 $resourceGroupLocation,

 [string]
 $deploymentName = 'Submit Speech Logic App Deployment',

 [string]
 $templateFilePath = "LogicApp.json",

 [string]
 $parametersFilePath
)

# sign in
#Write-Host "Logging in...";
#Login-AzAccount;

# select subscription
Write-Host "Selecting subscription '$subscriptionId'";
$subscription = Select-AzSubscription -SubscriptionID $subscriptionId;

#$connectionExists = Get-AzResource -ApiVersion '2016-06-01' -ResourceType "Microsoft.Web/connections" -ResourceGroupName $resourceGroupName -ResourceName "SubmitSpeech" -ErrorAction SilentlyContinue

#if(!$connectionExists)
#{
	New-AzResource -Properties @{"api" = @{"id" = "subscriptions/" + $subscriptionId + "/providers/Microsoft.Web/locations/" + $resourceGroupLocation + "/managedApis/" + 'azureeventgrid'}; "displayName" = 'SubmitSpeech'; } -ResourceName 'SubmitSpeech' -ResourceType "Microsoft.Web/connections" -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation -Force

	$connection = Get-AzResource -ApiVersion '2016-06-01' -ResourceType "Microsoft.Web/connections" -ResourceGroupName $resourceGroupName -ResourceName "SubmitSpeech"

	New-AzResource -Properties @{"api" = @{"id" = "subscriptions/" + $subscriptionId + "/providers/Microsoft.Web/locations/" + $resourceGroupLocation + "/managedApis/" + 'azureeventgridpublish'}; "displayName" = 'EliTMessageHandlerTopic'; } -ResourceName 'EliTMessageHandlerTopic' -ResourceType "Microsoft.Web/connections" -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation -Force

	$connection = Get-AzResource -ApiVersion '2016-06-01' -ResourceType "Microsoft.Web/connections" -ResourceGroupName $resourceGroupName -ResourceName "EliTMessageHandlerTopic"
#}

# Start the deployment
Write-Host "Starting deployment of Submit Speech Logic App";
if(Test-Path $parametersFilePath) {
    New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath -TemplateParameterFile $parametersFilePath;
} else {
    New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath;
}
Write-Host "Completed deployment of Submit Speech Logic App";