param resourceName string
param location string

// Create storage account queue on the provisioned storage account
// Later used as a consumer for the event grid
resource aksEventsQueue 'Microsoft.Storage/storageAccounts/queueServices/queues@2021-09-01' = {
  name: '${resourceName}-queue'
  parent: saQueueService
}

// Create Storage account Queue service
resource saQueueService 'Microsoft.Storage/storageAccounts/queueServices@2021-09-01' = {
  name: 'default'
  parent: storageAccount
}

// Create storage account
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: resourceName
  location: location
  sku: {
    name: 'Standard_GRS'
  }
  kind: 'StorageV2'
  properties:{
    accessTier: 'Hot'
  }
}
output storageAccountName string = storageAccount.name
output storageQueueName string = aksEventsQueue.name
