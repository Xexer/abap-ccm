@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Score for Dashboard'
@Metadata.allowExtensions: true
@OData.applySupportedForAggregation: #FULL
define view entity ZBC_C_CCMDashboardScore
  as projection on ZBC_I_CCMDashboardScore
{
  key ProviderID,
  key CalculationMethod,
  key RunTime,
      RunPeriod,
      @Aggregation.default: #SUM
      LevelAObjects,
      @Aggregation.default: #SUM
      LevelBObjects,
      @Aggregation.default: #SUM
      LevelCObjects,
      @Aggregation.default: #SUM
      LevelDObjects,
      TechnicalDebtScore,
      KeyUserObjects,
      _Dashboard : redirected to parent ZBC_C_CCMDashboard
}
