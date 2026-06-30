@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Checks'
@Metadata.allowExtensions: true
define root view entity ZBC_C_CCMChecks
  provider contract transactional_query
  as projection on ZBC_R_CCMChecks
{
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMProviderVH', element : 'ProviderId' } }]
      @ObjectModel.text.element: [ 'SystemName' ]
      @UI.textArrangement: #TEXT_ONLY
  key ProviderId,
  key CheckTitle,
  key CheckMessage,
      NumberOfCalls,
      _Provider.SystemName
}
