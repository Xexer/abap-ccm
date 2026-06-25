@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Score for Dashboard'
define view entity ZBC_I_CCMDashboardScore
  as select from ZBC_I_CCMScore
  association to parent ZBC_R_CCMDashboard as _Dashboard on  _Dashboard.ProviderID        = $projection.providerid
                                                         and _Dashboard.CalculationMethod = $projection.CalculationMethod
{
  key _Run.ProviderID,
  key CalculationMethod,
  key _Run.RunTime,
      LevelAObjects,
      LevelBObjects,
      LevelCObjects,
      LevelDObjects,
      TechnicalDebtScore,
      _Dashboard
}
