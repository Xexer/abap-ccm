@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Score for Dashboard'
@Metadata.allowExtensions: true
define view entity ZBC_C_CCMDashboardScore
  as projection on ZBC_I_CCMDashboardScore
{
  key ProviderID,
  key CalculationMethod,
  key RunTime,
      LevelAObjects,
      LevelBObjects,
      LevelCObjects,
      LevelDObjects,
      TechnicalDebtScore,
      _Dashboard : redirected to parent ZBC_C_CCMDashboard
}
