@sys.description('The Web App name.')
@minLength(3)
@maxLength(24)
param appServiceAppName string = 'jseijas-app-bicep'
@sys.description('The App Service Plan name.')
@minLength(3)
@maxLength(24)
param appServicePlanName string = 'jseijas-app-bicep'
@sys.description('The Storage Account name.')
@minLength(3)
@maxLength(24)
param appServiceAppName2 string = 'jseijas-app-bicep'
@sys.description('The App Service Plan name.')
@minLength(3)
@maxLength(24)
param appServicePlanName2 string = 'jseijas-app-bicep'
@sys.description('The Storage Account name.')
@minLength(3)
@maxLength(24)
param storageAccountName string = 'jseijasstorage'
@allowed([
  'nonprod'
  'prod'
  ])
param environmentType string = 'nonprod'
param location string = resourceGroup().location
@secure()
param dbhost string
@secure()
param dbuser string
@secure()
param dbpass string
@secure()
param dbname string

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'  

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
    name: storageAccountName
    location: location
    sku: {
      name: storageAccountSkuName
    }
    kind: 'StorageV2'
    properties: {
      accessTier: 'Hot'
    }
  }


  module appService1 'modules/appStuff.bicep' = if (environmentType == 'prod') {
    name: 'appService1'
    params: { 
      location: location
      appServiceAppName: appServiceAppName
      appServicePlanName: appServicePlanName
      dbhost: dbhost
      dbuser: dbuser
      dbpass: dbpass
      dbname: dbname
      environmentType: environmentType
    }
  }
  
  module appService2 'modules/appStuff.bicep' = if (environmentType == 'prod') {
    name: 'appService3'
    params: { 
      location: location
      appServiceAppName: appServiceAppName2
      appServicePlanName: appServicePlanName2
      dbhost: dbhost
      dbuser: dbuser
      dbpass: dbpass
      dbname: dbname
      environmentType: environmentType
    }
  }

  output appServiceAppHostName1 string = (environmentType == 'prod') ? appService1.outputs.appServiceAppHostName : appService1.outputs.appServiceAppHostName
  output appServiceAppHostName2 string = (environmentType == 'prod') ? appService2.outputs.appServiceAppHostName : appService2.outputs.appServiceAppHostName

    