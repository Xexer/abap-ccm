@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption for Score'
@Metadata.allowExtensions: true
define view entity ZBC_C_CCMScore
  as projection on ZBC_I_CCMScore
{
  key RunID,
  key CalculationMethod,
      LevelAObjects,
      LevelBObjects,
      LevelCObjects,
      LevelDObjects,
      TechnicalDebtScore,
      _Run : redirected to parent ZBC_C_CCMRun
}
