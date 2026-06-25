@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dashboard'
define view entity ZBC_I_CCMDashboardRuns as select from ZBC_R_CCMRun
{
  key ProviderID,
  max( RunTime ) as ActualRunTime
}
group by ProviderID
