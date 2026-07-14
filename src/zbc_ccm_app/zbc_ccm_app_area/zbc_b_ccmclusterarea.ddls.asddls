@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Base for Cluster Area'
define view entity ZBC_B_CCMClusterArea
  as select distinct from ZBC_R_CCMObjects
{
  key ProviderId,
  key _Cluster.ClusterID,
      Classification,
      PackageName,
      _Classification,
      _Cluster,
      _Provider
}
