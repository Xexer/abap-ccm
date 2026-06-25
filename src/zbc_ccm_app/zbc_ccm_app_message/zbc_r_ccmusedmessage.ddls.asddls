@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Messages'
define root view entity ZBC_R_CCMUsedMessage
  as select from zbc_ccm_msg
  association of exact one to one ZBC_I_CCMProviderVH as _Provider on _Provider.ProviderId = $projection.ProviderId
  association of exact one to one ZBC_I_CCMPriorityVH as _Priority on _Priority.Priority = $projection.Priority
{
  key provider_id   as ProviderId,
  key obj_type      as ObjType,
  key obj_name      as ObjName,
  key finding_id    as FindingId,
      priority      as Priority,
      check_title   as CheckTitle,
      check_message as CheckMessage,
      ref_obj_type  as RefObjType,
      ref_obj_name  as RefObjName,
      _Provider,
      _Priority
}
