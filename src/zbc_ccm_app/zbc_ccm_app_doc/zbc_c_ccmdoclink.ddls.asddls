@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Document Link'
@Metadata.allowExtensions: true
define view entity ZBC_C_CCMDocLink
  as projection on ZBC_I_CCMDocLink
{
  key LinkId,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMProviderVH', element : 'ProviderId' } }]
      @ObjectModel.text.element: [ 'SystemName' ]
      @UI.textArrangement: #TEXT_ONLY
      ProviderId,
      _Provider.SystemName,
      ObjectType,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMObjectVH', element : 'ObjectName' },
          additionalBinding: [{ localElement: 'ObjectType', element: 'ObjectType', usage: #RESULT },
                              { localElement: 'ProviderId', element: 'ProviderId', usage: #RESULT }] }]
      ObjectName,
      DocumentId,
      _Document : redirected to parent ZBC_C_CCMDocument
}
