# connect to Azure tenant subscription
Connect-AzAccount
$context = Get-AzSubscription -SubscriptionId your-0000-0000-0000-subscriptionID
Set-AzContext $context
