@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZBC_CCMRun'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZBC_R_CCMRun
  as select from zbc_ccm_run as Runs
  composition of exact one to many ZBC_I_CCMScore as _Score
{
  key run_id                as RunID,
      provider_id           as ProviderID,
      run_time              as RunTime,
      run_status            as RunStatus,
      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      _Score
}
