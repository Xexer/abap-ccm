@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Not Assigned Packages'
@Search.searchable: true
define view entity ZBC_I_CCMNotAssignedPackagesVH
  as select from ZBC_I_CCMNotAssignedPackages
{
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMProviderVH', element : 'ProviderId' } }]
      @ObjectModel.text.element: [ 'SystemName' ]
      @UI.textArrangement: #TEXT_ONLY
  key ProviderId,
  key ObjectType,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key ObjectName,
      SystemName
}
where
  IsAssigned = ''
