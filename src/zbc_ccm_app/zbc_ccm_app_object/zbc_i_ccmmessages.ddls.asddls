@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Messages'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZBC_I_CCMMessages
  as select from zbc_ccm_msg
  association              to parent ZBC_R_CCMObjects as _Objects  on  _Objects.ProviderId = $projection.ProviderId
                                                                   and _Objects.ObjectType = $projection.ObjectType
                                                                   and _Objects.ObjectName = $projection.ObjectName
  association of exact one to one ZBC_I_CCMPriorityVH as _Priority on  _Priority.Priority = $projection.Priority
{
  key provider_id   as ProviderId,
  key obj_type      as ObjectType,
  key obj_name      as ObjectName,
  key finding_id    as FindingId,
      priority      as Priority,
      check_title   as CheckTitle,
      check_message as CheckMessage,
      ref_obj_type  as RefObjType,
      ref_obj_name  as RefObjName,
      _Objects,
      _Priority
}
