@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VH for ATC Check Message'
define view entity ZBC_I_CCMATCCheckMessageVH
  as select from ZBC_I_CCMATCMessage
{
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMATCCheckVH', element : 'CheckName' } }]
  key CheckName,
      @ObjectModel.text.element: [ 'MessageText' ]
      @UI.textArrangement: #TEXT_ONLY
  key MessageName,
      MessageText
}
