@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Used APIs'
define root view entity ZBC_R_CCMUsedAPIs
  as select from zbc_ccm_msg
  association of exact one to one ZBC_I_CCMProviderVH as _Provider on _Provider.ProviderId = $projection.ProviderId
{
  key provider_id  as ProviderId,
  key ref_obj_type as RefObjType,
  key ref_obj_name as RefObjName,
      count( * )   as NumberOfCalls,
      _Provider
}
group by
  $projection.providerid,
  $projection.refobjtype,
  $projection.refobjname
