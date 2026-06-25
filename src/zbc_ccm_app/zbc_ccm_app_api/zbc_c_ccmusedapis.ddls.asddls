@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Used APIs'
@Metadata.allowExtensions: true
define root view entity ZBC_C_CCMUsedAPIs
  provider contract transactional_query
  as projection on ZBC_R_CCMUsedAPIs
{
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMProviderVH', element : 'ProviderId' } }]
      @ObjectModel.text.element: [ 'SystemName' ]
      @UI.textArrangement: #TEXT_ONLY
  key ProviderId,
  key RefObjType,
  key RefObjName,
      NumberOfCalls,
      _Provider.SystemName
}
