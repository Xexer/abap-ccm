@EndUserText.label: 'Choose Cluster Popup'
define abstract entity ZBC_S_CCMClusterChoose
{
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZBC_I_CCMClusterVH', element : 'ClusterID' } }]
  @ObjectModel.text.element: [ 'ClusterName' ]
  @UI.textArrangement: #TEXT_ONLY
  ClusterID   : zbc_ccm_cluster_id;

  @UI.hidden  : true
  ClusterName : zbc_ccm_cluster_name;
}
