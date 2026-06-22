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
      ProviderID,
      RunTime,
      RunStatus,
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
