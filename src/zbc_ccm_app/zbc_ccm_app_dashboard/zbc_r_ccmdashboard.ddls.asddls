@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dashboard'
define root view entity ZBC_R_CCMDashboard
  as select from    ZBC_R_CCMRun
    inner join      ZBC_I_CCMDashboardRuns as _MaxRun on  _MaxRun.ProviderID    = ZBC_R_CCMRun.ProviderID
                                                      and _MaxRun.ActualRunTime = ZBC_R_CCMRun.RunTime
    left outer join ZBC_I_CCMScore         as _Score  on _Score.RunID = ZBC_R_CCMRun.RunID
  composition of exact one to many ZBC_I_CCMDashboardScore as _OtherScores
  association of exact one to one ZBC_I_CCMProviderCust    as _Provider on _Provider.ProviderId = ZBC_R_CCMRun.ProviderID
{
  key ZBC_R_CCMRun.ProviderID,
  key _Score.CalculationMethod,
      _Score.TechnicalDebtScore,
      cast( _Score.LevelAObjects as zbc_ccm_objects_char ) as LevelAObjects,
      cast( _Score.LevelBObjects as zbc_ccm_objects_char ) as LevelBObjects,
      cast( _Score.LevelCObjects as zbc_ccm_objects_char ) as LevelCObjects,
      cast( _Score.LevelDObjects as zbc_ccm_objects_char ) as LevelDObjects,
      _Score.KeyUserObjects,
      _OtherScores,
      ZBC_R_CCMRun._Provider,
      ZBC_R_CCMRun.RunTime,
      _Score._CalcMethod
}
where
  _Provider.Active = 'X'
