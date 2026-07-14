@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Objects'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZBC_R_CCMObjects
  as select from zbc_ccm_obj
  composition of exact one to many ZBC_I_CCMMessages        as _Messages
  association of exact one to one ZBC_I_CCMClassificationVH as _Classification on  _Classification.Classification = $projection.Classification
  association of exact one to one ZBC_I_CCMProviderVH       as _Provider       on  _Provider.ProviderId = $projection.ProviderId
  association of one       to one ZBC_I_CCMAssignmentVH     as _Cluster        on  _Cluster.ProviderID = $projection.ProviderId
                                                                               and _Cluster.ObjectType = 'DEVC'
                                                                               and _Cluster.ObjectName = $projection.PackageName
{
  key provider_id        as ProviderId,
  key obj_type           as ObjectType,
  key obj_name           as ObjectName,
      package_name       as PackageName,
      person_responsible as PersonResponsible,
      classification     as Classification,
      number_error       as NumberError,
      number_warning     as NumberWarning,
      number_info        as NumberInfo,
      debt_score         as DebtScore,
      _Messages,
      _Classification,
      _Provider,
      _Cluster
}
