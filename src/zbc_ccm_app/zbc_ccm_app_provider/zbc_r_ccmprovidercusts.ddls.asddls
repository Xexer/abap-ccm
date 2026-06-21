@EndUserText.label: 'Provider Customizing Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Semantics.valueRange.maximum: '1'
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'ProviderCustAll'
  }
}
define root view entity ZBC_R_CCMProviderCustS
  as select from I_Language
    left outer join zbc_ccm_prov on 0 = 0
  composition [0..*] of ZBC_I_CCMProviderCust as _ProviderCust
{
  @UI.facet: [ {
    id: 'ProviderCust', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'Provider Customizing', 
    position: 1 , 
    targetElement: '_ProviderCust'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  @UI.identification: [{ position: 10, type: #FOR_ACTION, dataAction: 'SyncAllProviders', label: 'Sync Providers' }]
  key 1 as SingletonID,
  _ProviderCust,
  @UI.hidden: true
  max( zbc_ccm_prov.last_changed_at ) as LastChangedAtMax
}
where I_Language.Language = $session.system_language
