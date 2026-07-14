@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cluster Assignment'
define view entity ZBC_I_CCMClusterAssignment
  as select from zbc_ccm_cassign
  association              to parent ZBC_R_CCMCluster as _Cluster  on _Cluster.ClusterID = $projection.ClusterID
  association of exact one to one ZBC_I_CCMProviderVH as _Provider on _Provider.ProviderId = $projection.ProviderID
{
  key object_id   as ObjectID,
      provider_id as ProviderID,
      obj_type    as ObjectType,
      obj_name    as ObjectName,
      cluster_id  as ClusterID,
      _Cluster,
      _Provider
}
