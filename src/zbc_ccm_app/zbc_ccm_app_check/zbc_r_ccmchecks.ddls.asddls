@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Checks'
define root view entity ZBC_R_CCMChecks
  as select from zbc_ccm_msg
  association of exact one to one ZBC_I_CCMProviderVH as _Provider on _Provider.ProviderId = $projection.ProviderId
{
  key provider_id   as ProviderId,
  key check_title   as CheckTitle,
  key check_message as CheckMessage,
      count( * )    as NumberOfCalls,
      _Provider
}
group by
  $projection.providerid,
  $projection.checktitle,
  $projection.checkmessage
