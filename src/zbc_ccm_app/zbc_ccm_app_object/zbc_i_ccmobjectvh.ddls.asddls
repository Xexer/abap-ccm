@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VH for Objects'
@Search.searchable: true
define view entity ZBC_I_CCMObjectVH
  as select from ZBC_R_CCMObjects
{
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMProviderVH', element : 'ProviderId' } }]
      @ObjectModel.text.element: [ 'SystemName' ]
      @UI.textArrangement: #TEXT_ONLY
  key ProviderId,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 1.0
      @EndUserText.label: 'Object Type'
  key ObjectType,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @EndUserText.label: 'Object Name'
  key ObjectName,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.9
      @EndUserText.label: 'Package'
      PackageName,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.9
      @EndUserText.label: 'Responsible'
      PersonResponsible,
      _Provider.SystemName
}
