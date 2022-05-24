param nameseed string = 'evgtsample'
param kubernetesVersion string = '1.21.7'
param location string =  resourceGroup().location

module eventSub 'event-subscriber.bicep' = {
  name: 'eventsubscription'
  params: {
    eventGridName: aksconst.outputs.eventGridName
    storageAccountName: storageQueue.outputs.storageAccountName
    storageQueueName: storageQueue.outputs.storageQueueName
  }
}

module storageQueue 'storage-queue.bicep' = {
  name: 'storagequeue'
  params: {
    location : location
    resourceName: 'st${nameseed}'
  }
}

//---------Kubernetes Construction---------
//ref: https://github.com/Azure/AKS-Construction

module aksconst '../../bicep/main.bicep' = {
  name: 'aksconstruction'
  params: {
    location : location
    resourceName: nameseed
    omsagent: true
    retentionInDays: 30
    agentCount: 1
    JustUseSystemPool: true
    createEventGrid: true
    kubernetesVersion: kubernetesVersion
  }
}
