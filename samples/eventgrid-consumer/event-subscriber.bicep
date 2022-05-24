param eventGridName string
param storageAccountName string
param storageQueueName string

// Create a reference to the existing storage account where queue resides
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: storageAccountName
}

// Create a reference to the existing Event Grid
resource eventGrid 'Microsoft.EventGrid/systemTopics@2021-12-01' existing = {
  name: eventGridName
}

// Create new Event Grid subscription once the RBAC is in place
resource eventGridSubscription 'Microsoft.EventGrid/systemTopics/eventSubscriptions@2021-12-01' = {
  name: 'evgs-${storageQueueName}'
  parent: eventGrid
  properties: {
    deliveryWithResourceIdentity: {
      destination: {
        endpointType: 'StorageQueue'
        properties: {
          queueName: storageQueueName
          resourceId: storageAccount.id
        }
      }
      identity: {
        type: 'SystemAssigned'
      }
    }
  }
  dependsOn: [
    queue_message_sender
  ]
}


// [RBAC] Assign 'Storage Queue Data Message Sender' role to event grid system identity within SA scope
var queueMsgSenderRole = resourceId('Microsoft.Authorization/roleDefinitions', 'c6a89b2d-59bc-44d0-9896-0f6e12d7b80a')

resource queue_message_sender 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: storageAccount // Use when specifying a scope that is different than the deployment scope
  name: guid(eventGrid.id, 'eventgrid', queueMsgSenderRole)
  properties: {
    roleDefinitionId: queueMsgSenderRole
    principalId: eventGrid.identity.principalId
    principalType: 'ServicePrincipal'
  }
}
