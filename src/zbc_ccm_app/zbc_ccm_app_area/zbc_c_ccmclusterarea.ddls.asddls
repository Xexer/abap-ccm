@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cluster Area for Cluster'
@Metadata.allowExtensions: true
define root view entity ZBC_C_CCMClusterArea
  provider contract transactional_query
  as projection on ZBC_R_CCMClusterArea
{
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMProviderVH', element : 'ProviderId' } }]
          @ObjectModel.text.element: [ 'SystemName' ]
          @UI.textArrangement: #TEXT_ONLY
  key     ProviderId,
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMClusterVH', element : 'ClusterID' } }]
          @ObjectModel.text.element: [ 'ClusterName' ]
          @UI.textArrangement: #TEXT_ONLY
  key     ClusterID,
          _Provider.SystemName,
          _ClusterName.ClusterName,
          LevelDObjects,
          LevelCObjects,
          LevelBObjects,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_BC_CCM_AREA_ELEM'
  virtual LevelDCriticality : abap.int1,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_BC_CCM_AREA_ELEM'
  virtual LevelCCriticality : abap.int1,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_BC_CCM_AREA_ELEM'
  virtual LevelBCriticality : abap.int1,

          _ClusterName,
          _Provider
}
