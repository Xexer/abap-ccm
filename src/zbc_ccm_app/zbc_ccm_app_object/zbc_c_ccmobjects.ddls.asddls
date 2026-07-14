@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Objects'
@Metadata.allowExtensions: true
define root view entity ZBC_C_CCMObjects
  provider contract transactional_query
  as projection on ZBC_R_CCMObjects
{
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMProviderVH', element : 'ProviderId' } }]
          @ObjectModel.text.element: [ 'SystemName' ]
          @UI.textArrangement: #TEXT_ONLY
  key     ProviderId,
  key     ObjectType,
  key     ObjectName,
          _Provider.SystemName,
          PackageName,
          PersonResponsible,
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMClassificationVH', element : 'Classification' } }]
          @ObjectModel.text.element: [ 'Description' ]
          @UI.textArrangement: #TEXT_ONLY
          Classification,
          _Classification.Description,
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMClusterVH', element : 'ClusterID' } }]
          @ObjectModel.text.element: [ 'ClusterName' ]
          @UI.textArrangement: #TEXT_ONLY
          _Cluster.ClusterID,
          _Cluster.ClusterName,
          NumberError,
          NumberWarning,
          NumberInfo,
          DebtScore,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_BC_CCM_OBJECT_ELEM'
  virtual ClassPriority    : abap.int1,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_BC_CCM_OBJECT_ELEM'
          @ObjectModel.text.element: [ 'ShortDescription' ]
          @UI.textArrangement: #TEXT_ONLY          
  virtual DocumentID       : zbc_ccm_document_id,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_BC_CCM_OBJECT_ELEM'
  virtual ShortDescription : zbc_ccm_short_desc,

          _Classification,
          _Messages : redirected to composition child ZBC_C_CCMMessages,
          _Provider
}
