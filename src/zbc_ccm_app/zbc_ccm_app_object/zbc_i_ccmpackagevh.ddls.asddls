@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VH for Packages'
@Search.searchable: true
define view entity ZBC_I_CCMPackageVH
  as select distinct from ZBC_R_CCMObjects
{
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMProviderVH', element : 'ProviderId' } }]
      @ObjectModel.text.element: [ 'SystemName' ]
      @UI.textArrangement: #TEXT_ONLY
  key ProviderId,
  key abap.char'DEVC' as ObjectType,
  @Search.defaultSearchElement: true 
  @Search.fuzzinessThreshold: 0.8
  key PackageName     as ObjectName,
      _Provider.SystemName
}
