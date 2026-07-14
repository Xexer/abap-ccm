@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZBC_Cluster'
define root view entity ZBC_R_CCMCluster
  as select from zbc_ccm_clstr as CCMCluster
  composition of exact one to many ZBC_I_CCMClusterAssignment as _Assignment
  association of exact one to one ZBC_I_CCMClusterAssignCount as _Count on _Count.ClusterID = $projection.ClusterID
{
  key cluster_id            as ClusterID,
      cluster_name          as ClusterName,
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
      _Assignment,
      _Count
}
