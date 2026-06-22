@EndUserText.label: 'Provider Customizing'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZBC_I_CCMProviderCust
  as select from zbc_ccm_prov
  association to parent ZBC_R_CCMProviderCustS as _ProviderCustAll on $projection.SingletonID = _ProviderCustAll.SingletonID
{
  key provider_id           as ProviderId,
      group_id              as GroupId,
      system_name           as SystemName,
      active                as Active,
      only_scores           as OnlyScores,
      ccap_id               as CustomCodeProjectID,
      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      @Consumption.hidden: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      @Consumption.hidden: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Consumption.hidden: true
      1                     as SingletonID,
      _ProviderCustAll
}
