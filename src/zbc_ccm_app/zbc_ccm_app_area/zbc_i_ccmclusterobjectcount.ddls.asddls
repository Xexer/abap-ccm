@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Object Count for Cluster'
define view entity ZBC_I_CCMClusterObjectCount
  as select from ZBC_R_CCMObjects
{
  key ProviderId,
  key _Cluster.ClusterID,
  key Classification,
      count( distinct ObjectName ) as NumberFindings
}
group by
  ProviderId,
  _Cluster.ClusterID,
  Classification
