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
          NumberError,
          NumberWarning,
          NumberInfo,
          DebtScore,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_BC_CCM_OBJECT_ELEM'
  virtual ClassPriority : abap.int1,

          _Classification,
          _Messages : redirected to composition child ZBC_C_CCMMessages,
          _Provider
}
