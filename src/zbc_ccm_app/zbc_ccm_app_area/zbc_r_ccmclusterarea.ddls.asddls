@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Area for Clusters'
define root view entity ZBC_R_CCMClusterArea
  as select distinct from ZBC_B_CCMClusterArea
  association of one       to one ZBC_I_CCMClusterObjectCount as _CountD      on  _CountD.ProviderId     = $projection.ProviderId
                                                                              and _CountD.ClusterID      = $projection.ClusterID
                                                                              and _CountD.Classification = 'D'
  association of one       to one ZBC_I_CCMClusterObjectCount as _CountC      on  _CountC.ProviderId     = $projection.ProviderId
                                                                              and _CountC.ClusterID      = $projection.ClusterID
                                                                              and _CountC.Classification = 'C'
  association of one       to one ZBC_I_CCMClusterObjectCount as _CountB      on  _CountB.ProviderId     = $projection.ProviderId
                                                                              and _CountB.ClusterID      = $projection.ClusterID
                                                                              and _CountB.Classification = 'B'
  association of exact one to one ZBC_I_CCMClusterVH          as _ClusterName on  _ClusterName.ClusterID = $projection.ClusterID
{
  key ProviderId,
  key ClusterID,

      _CountD.NumberFindings as LevelDObjects,
      _CountC.NumberFindings as LevelCObjects,
      _CountB.NumberFindings as LevelBObjects,
      _Provider,
      _ClusterName
}
where
  ClusterID is not initial
