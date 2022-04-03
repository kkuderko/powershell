# connect to Azure AD
#$UserCredential = Get-Credential -Credential azureADadmin@yourdomain.onmicrosoft.com
Connect-AzureAD

#Connect-AzureAD -Credential $UserCredential
#Connect-AzAccount -Credential $UserCredential