@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZBC_CCMCustomAPI'
define root view entity ZBC_R_CCMCustomAPIs
  as select from zbc_ccm_custom as CustomAPI
  association of exact one to one ZBC_I_CCMProviderVH      as _Provider   on _Provider.ProviderId = $projection.ProviderID
  association of exact one to one ZBC_I_CCMObjectTypeAPIVH as _ObjectType on _ObjectType.ObjectType = $projection.ObjectType
{
  key provider_id           as ProviderID,
  key obj_type              as ObjectType,
  key obj_name              as ObjectName,
      short_description     as ShortDescription,
      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      _Provider,
      _ObjectType
}
