@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cluster Assignment'
@Metadata.allowExtensions: true
define view entity ZBC_C_CCMClusterAssignment
  as projection on ZBC_I_CCMClusterAssignment
{
  key ObjectID,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMProviderVH', element : 'ProviderId' } }]
      @ObjectModel.text.element: [ 'SystemName' ]
      @UI.textArrangement: #TEXT_ONLY
      ProviderID,
      _Provider.SystemName,
      ObjectType,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMNotAssignedPackagesVH', element : 'ObjectName' },
                                          additionalBinding: [{ localElement: 'ProviderID', element: 'ProviderId' },
                                                              { localElement: 'ObjectType', element: 'ObjectType' }]
      }]
      ObjectName,
      ClusterID,
      _Cluster : redirected to parent ZBC_C_CCMCluster
}
