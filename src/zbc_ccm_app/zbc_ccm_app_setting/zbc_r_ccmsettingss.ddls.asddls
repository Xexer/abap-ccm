@EndUserText.label: 'Settings Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Semantics.valueRange.maximum: '1'
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'SettingsAll'
  }
}
define root view entity ZBC_R_CCMSettingsS
  as select from I_Language
    left outer join ZBC_CCM_SETT on 0 = 0
  composition [0..*] of ZBC_I_CCMSettings as _Settings
{
  @UI.facet: [ {
    id: 'Settings', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'Settings', 
    position: 1 , 
    targetElement: '_Settings'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _Settings,
  @UI.hidden: true
  max( ZBC_CCM_SETT.LAST_CHANGED_AT ) as LastChangedAtMax
}
where I_Language.Language = $session.system_language
