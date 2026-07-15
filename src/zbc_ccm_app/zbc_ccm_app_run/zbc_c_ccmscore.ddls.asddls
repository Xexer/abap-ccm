@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption for Score'
@Metadata.allowExtensions: true
define view entity ZBC_C_CCMScore
  as projection on ZBC_I_CCMScore
{
  key RunID,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMCalculationMethod', element : 'CalculationMethod' } }]
      @ObjectModel.text.element: [ 'Description' ]
      @UI.textArrangement: #TEXT_ONLY
  key CalculationMethod,
      _CalcMethod.Description,
      LevelAObjects,
      LevelBObjects,
      LevelCObjects,
      LevelDObjects,
      TechnicalDebtScore,
      KeyUserObjects,
      _Run : redirected to parent ZBC_C_CCMRun
}
