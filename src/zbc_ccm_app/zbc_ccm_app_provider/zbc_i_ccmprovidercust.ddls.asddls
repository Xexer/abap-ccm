@EndUserText.label: 'Provider Customizing'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZBC_I_CCMProviderCust
  as select from ZBC_CCM_PROV
  association to parent ZBC_R_CCMProviderCustS as _ProviderCustAll on $projection.SingletonID = _ProviderCustAll.SingletonID
{
  key PROVIDER_ID as ProviderId,
  GROUP_ID as GroupId,
  SYSTEM_NAME as SystemName,
  ACTIVE as Active,
  ONLY_SCORES as OnlyScores,
  @Semantics.user.createdBy: true
  LOCAL_CREATED_BY as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  LOCAL_CREATED_AT as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  @Consumption.hidden: true
  LOCAL_LAST_CHANGED_BY as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  @Consumption.hidden: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt,
  @Consumption.hidden: true
  1 as SingletonID,
  _ProviderCustAll
}
