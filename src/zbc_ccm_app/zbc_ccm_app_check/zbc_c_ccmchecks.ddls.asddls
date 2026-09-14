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
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMATCCheckVH', element : 'CheckName' } }]
      @ObjectModel.text.element: [ 'CheckText' ]
      @UI.textArrangement: #TEXT_ONLY
  key CheckName,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMATCCheckMessageVH', element : 'MessageName' } }]
      @ObjectModel.text.element: [ 'MessageText' ]
      @UI.textArrangement: #TEXT_ONLY
  key MessageName,
      _Message.MessageText,
      _Check.CheckText,
      NumberOfCalls,
      _Provider.SystemName
}
