@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dashboard'
@Metadata.allowExtensions: true
define root view entity ZBC_C_CCMDashboard
  provider contract transactional_query
  as projection on ZBC_R_CCMDashboard
{
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMProviderVH', element : 'ProviderId' } }]
          @ObjectModel.text.element: [ 'SystemName' ]
          @UI.textArrangement: #TEXT_ONLY
  key     ProviderID,
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMCalculationMethod', element : 'CalculationMethod' } }]
          @ObjectModel.text.element: [ 'Description' ]
          @UI.textArrangement: #TEXT_ONLY
          @Consumption.filter.mandatory: true
          @Consumption.filter.defaultValue: ''
          @Consumption.filter.selectionType: #SINGLE
  key     CalculationMethod,
          _Provider.SystemName,
          _CalcMethod.Description,
          TechnicalDebtScore,
          LevelAObjects,
          LevelBObjects,
          LevelCObjects,
          LevelDObjects,
          
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_BC_CCM_DASHBOARD_ELEM'
  virtual CloudReady        : abap.char(10),
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_BC_CCM_DASHBOARD_ELEM'
  virtual UpgradeStable     : abap.char(10),
  
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_BC_CCM_DASHBOARD_ELEM'
  virtual CriticalityLevelA : int1,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_BC_CCM_DASHBOARD_ELEM'
  virtual CriticalityLevelB : int1,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_BC_CCM_DASHBOARD_ELEM'
  virtual CriticalityLevelC : int1,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_BC_CCM_DASHBOARD_ELEM'
  virtual CriticalityLevelD : int1,
    
          _OtherScores : redirected to composition child ZBC_C_CCMDashboardScore
}
