@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VH for Object Provider'
define view entity ZBC_I_CCMProviderVH
  as select from ZBC_I_CCMProviderCust
{
      @ObjectModel.text.element: [ 'SystemName' ]
      @UI.textArrangement: #TEXT_ONLY
  key ProviderId,
      SystemName
}
where
  Active = 'X'
