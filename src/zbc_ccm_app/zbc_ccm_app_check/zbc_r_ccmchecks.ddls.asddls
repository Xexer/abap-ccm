@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Checks'
define root view entity ZBC_R_CCMChecks
  as select from zbc_ccm_msg
  association of exact one to one ZBC_I_CCMProviderVH        as _Provider on  _Provider.ProviderId = $projection.ProviderId
  association of exact one to one ZBC_I_CCMATCCheckVH        as _Check    on  _Check.CheckName = $projection.CheckName
  association of exact one to one ZBC_I_CCMATCCheckMessageVH as _Message  on  _Message.CheckName   = $projection.CheckName
                                                                          and _Message.MessageName = $projection.MessageName
{
  key provider_id  as ProviderId,
  key check_name   as CheckName,
  key message_name as MessageName,
      count( * )   as NumberOfCalls,
      _Provider,
      _Check,
      _Message
}
group by
  $projection.ProviderId,
  $projection.CheckName,
  $projection.MessageName
