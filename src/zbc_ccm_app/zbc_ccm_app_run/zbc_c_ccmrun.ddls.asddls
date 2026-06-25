@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZBC_CCMRun'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZBC_C_CCMRun
  provider contract transactional_query
  as projection on ZBC_R_CCMRun
  association [1..1] to ZBC_R_CCMRun as _BaseEntity on $projection.RunID = _BaseEntity.RunID
{
  key RunID,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMProviderVH', element : 'ProviderId' } }]
      @ObjectModel.text.element: [ 'SystemName' ]
      @UI.textArrangement: #TEXT_ONLY
      ProviderID,
      _Provider.SystemName,
      RunTime,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMRunStatusVH', element : 'RunStatus' } }]
      @ObjectModel.text.element: [ 'Description' ]
      @UI.textArrangement: #TEXT_ONLY
      RunStatus,
      _RunStatus.Description,
      @Semantics: {
        user.createdBy: true
      }
      LocalCreatedBy,
      @Semantics: {
        systemDateTime.createdAt: true
      }
      LocalCreatedAt,
      @Semantics: {
        user.localInstanceLastChangedBy: true
      }
      LocalLastChangedBy,
      @Semantics: {
        systemDateTime.localInstanceLastChangedAt: true
      }
      LocalLastChangedAt,
      @Semantics: {
        systemDateTime.lastChangedAt: true
      }
      LastChangedAt,
      _BaseEntity,
      _Score : redirected to composition child ZBC_C_CCMScore
}
