@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Cluster'
@Search.searchable: true
define view entity ZBC_I_CCMClusterVH
  as select from ZBC_R_CCMCluster
{
      @ObjectModel.text.element: [ 'ClusterName' ]
      @UI.textArrangement: #TEXT_ONLY
  key ClusterID,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      ClusterName
}
