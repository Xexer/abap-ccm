@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Not Assigned Packages'
@Metadata.allowExtensions: true
define root view entity ZBC_C_CCMNotAssignedPackages
  provider contract transactional_query
  as projection on ZBC_R_CCMNotAssignedPackages
{
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMProviderVH', element : 'ProviderId' } }]
      @ObjectModel.text.element: [ 'SystemName' ]
      @UI.textArrangement: #TEXT_ONLY
  key ProviderId,
  key ObjectType,
  key ObjectName,
      SystemName,
      @Consumption.filter.defaultValue: ''
      IsAssignedBool,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMClusterVH', element : 'ClusterID' } }]
      @ObjectModel.text.element: [ 'ClusterName' ]
      @UI.textArrangement: #TEXT_ONLY
      ClusterID,
      _Assignment._Cluster.ClusterName,
      _Assignment,
      _Provider
}
