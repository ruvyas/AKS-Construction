# AKS events with Event Grid & Subscriber - Sample

> Currently, AKS events with Event Grid is in preview.
>
> Please [register the Event Grid Preview feature](https://docs.microsoft.com/en-us/azure/aks/quickstart-event-grid#register-the-eventgridpreview-preview-feature) before deploying this sample

This sample shows how to use a Storage Queue as a consumer/subscriber to the AKS Event Grid System Topic.

Specifically it shows;

1. Creation of the Storage Account & Storage Queue
2. Creation of Event Grid Subscription on an existing Event Grid System Topic
3. Scoped RBAC assignment of the 'Storage Queue Data Message Sender' Role

## Deploying the sample

```bash
RG=yourAksResourceGroup
kubernetesVersion=olderVersionOfKubernetes

az deployment group create -g $RG -f .\samples\eventgrid-consumer\main.bicep -p kubernetesVersion=$kubernetesVersion
```