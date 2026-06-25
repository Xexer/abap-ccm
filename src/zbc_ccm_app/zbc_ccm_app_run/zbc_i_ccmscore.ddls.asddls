@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Scores'
define view entity ZBC_I_CCMScore
  as select from zbc_ccm_score
  association to parent ZBC_R_CCMRun as _Run on _Run.RunID = $projection.RunID
  association of exact one to one ZBC_I_CCMCalculationMethod as _CalcMethod on _CalcMethod.CalculationMethod = $projection.CalculationMethod
{
  key run_id           as RunID,
  key calculate_method as CalculationMethod,
      level_a          as LevelAObjects,
      level_b          as LevelBObjects,
      level_c          as LevelCObjects,
      level_d          as LevelDObjects,
      debt_score       as TechnicalDebtScore,
      _Run,
      _CalcMethod
}
