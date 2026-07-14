@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VH for Assignment'
define view entity ZBC_I_CCMAssignmentVH
  as select from ZBC_I_CCMClusterAssignment
{
  key ProviderID,
  key ObjectType,
  key ObjectName,
      ClusterID,
      _Cluster.ClusterName
}
